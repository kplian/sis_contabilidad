<?php
/**   
*@package pXP
*@file gen-ACTDocCompraVenta.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 * 
 *  *    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		  18-08-2015         N/N               creacion
 #1200  ETR       12/07/2018        RAC KPLIAN        filtros para relacioanr notas de debito credito
 #1999  ETR       19/07/2018        RAC KPLIAN        Relacionar facturas NCD
 #2000  ETR       20/08/2018        EGS               aumento filtro  listar DocCompraVenta Cobro
 #1201  ETR       11/09/2018        RAC               Adciona filtro apra buscar en varios tipos de informe  tipos_infromes 
 #2001  ETR       12/09/2018        EGS               aumento filtros para listar DocCompraVenta Cobro  para anticipos y facturas regularizadas
 #12   ETR       17/10/2018        RAC KPLIAN        El listado de factura normales se excluyer las facturas del tipo inform NCD  
 #112			  17/04/2020		manu				 reportes de autorizacion de pasajes y registro de pasajeros
#113  ETR       29/04/2020		     MMV	             Reporte Registro Ventas CC


 * */
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RLcv.php');
require_once(dirname(__FILE__).'/../reportes/RLcvVentas.php');
require_once(dirname(__FILE__).'/../../sis_contabilidad/reportes/RepAutorizacion.php');
require_once(dirname(__FILE__).'/../../sis_contabilidad/reportes/RepRegPasa.php');
require_once(dirname(__FILE__).'/../reportes/RReporteRegistrosVentaCC.php');

class ACTDocCompraVenta extends ACTbase{    
			
	function listarDocCompraVenta(){
		$this->objParam->defecto('ordenacion','id_doc_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
            $this->objParam->addFiltro("dcv.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));    
        }
		
		if($this->objParam->getParametro('tipo')!=''){
            $this->objParam->addFiltro("dcv.tipo = ''".$this->objParam->getParametro('tipo')."''");    
        }
		
		if($this->objParam->getParametro('sin_cbte')=='si'){
            $this->objParam->addFiltro("dcv.id_int_comprobante is NULL");    
        }
		/* en algunos casos es necesario relacionar con documentos con fechas mayores
		if($this->objParam->getParametro('manual')!=''){
            $this->objParam->addFiltro("dcv.manual = ''".$this->objParam->getParametro('manual')."''");    
        }*/
		
		//RCM comentado en fecha 27/02/2018 para asociar facturas coin fecha posterior al Cbte. previa consulta a RAC
		/*if($this->objParam->getParametro('fecha_cbte')!=''){
            $this->objParam->addFiltro("dcv.fecha <= ''".$this->objParam->getParametro('fecha_cbte')."''::date");    
        }*/

        if($this->objParam->getParametro('filtro_usuario') == 'si'){
            $this->objParam->addFiltro("dcv.id_usuario_reg = ".$_SESSION["ss_id_usuario"]);
        }
		
		if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }
		
		if($this->objParam->getParametro('id_agrupador')!=''){
            $this->objParam->addFiltro("dcv.id_doc_compra_venta not in (select ad.id_doc_compra_venta from conta.tagrupador_doc ad where ad.id_agrupador = ".$this->objParam->getParametro('id_agrupador').") ");    
        }
		
		//#1200  --filtro fecha
		if($this->objParam->getParametro('fecha') !=''){
            $this->objParam->addFiltro("dcv.fecha <= ''".$this->objParam->getParametro('fecha')."''::date");
        }
		//#1200  --filtro NIT
        if($this->objParam->getParametro('nit') !=''){
            $this->objParam->addFiltro("dcv.nit = ''".$this->objParam->getParametro('nit')."''");
        }
		
		
		if($this->objParam->getParametro('tipo_informe') !=''){
            $this->objParam->addFiltro("pla.tipo_informe = ''".$this->objParam->getParametro('tipo_informe')."''");
        }

       //#1200  FIN 
	   //#1201 add tipos_informes, para listar facturas LCV y facturas regularizadas
       if($this->objParam->getParametro('tipos_informes') !=''){
            $this->objParam->addFiltro("pla.tipo_informe in (".$this->objParam->getParametro('tipos_informes').")");
        }
		
		//#123  se exlcuye facturas NCD de los listados de compra y ventas...
		if($this->objParam->getParametro('nombre_vista') =='DocCompra' || $this->objParam->getParametro('nombre_vista') =='DocVenta'){
			$this->objParam->addFiltro("pla.tipo_informe not in (''ncd'')");
		}
		
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocCompraVenta','listarDocCompraVenta');
		} else{
			$this->objFunc=$this->create('MODDocCompraVenta');			
			$this->res=$this->objFunc->listarDocCompraVenta($this->objParam);
		}
		
		
	
		$temp = Array();
			$temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
			$temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
			$temp['importe_it'] = $this->res->extraData['total_importe_it'];
			$temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
			$temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
			$temp['importe_doc'] = $this->res->extraData['total_importe_doc'];			
			$temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
			$temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
			$temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
			$temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
			$temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
			$temp['importe_pago_liquido'] = $this->res->extraData['total_importe_pago_liquido'];	
			$temp['importe_aux_neto'] = $this->res->extraData['total_importe_aux_neto'];	
					
			$temp['tipo_reg'] = 'summary';
			$temp['id_doc_compra_venta'] = 0;
			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}




 function listarDocCompraVentaCobro(){
		$this->objParam->defecto('ordenacion','id_doc_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
            $this->objParam->addFiltro("dcv.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));    
        }
		
		if($this->objParam->getParametro('tipo')!=''){
            $this->objParam->addFiltro("dcv.tipo = ''".$this->objParam->getParametro('tipo')."''");    
        }
		
		if($this->objParam->getParametro('sin_cbte')=='si'){
            $this->objParam->addFiltro("dcv.id_int_comprobante is NULL");    
        }
		/* en algunos casos es necesario relacionar con documentos con fechas mayores
		if($this->objParam->getParametro('manual')!=''){
            $this->objParam->addFiltro("dcv.manual = ''".$this->objParam->getParametro('manual')."''");    
        }*/
		
		//RCM comentado en fecha 27/02/2018 para asociar facturas coin fecha posterior al Cbte. previa consulta a RAC
		/*if($this->objParam->getParametro('fecha_cbte')!=''){
            $this->objParam->addFiltro("dcv.fecha <= ''".$this->objParam->getParametro('fecha_cbte')."''::date");    
        }*/

        if($this->objParam->getParametro('filtro_usuario') == 'si'){
            $this->objParam->addFiltro("dcv.id_usuario_reg = ".$_SESSION["ss_id_usuario"]);
        }
		
		if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }
		
		if($this->objParam->getParametro('id_agrupador')!=''){
            $this->objParam->addFiltro("dcv.id_doc_compra_venta not in (select ad.id_doc_compra_venta from conta.tagrupador_doc ad where ad.id_agrupador = ".$this->objParam->getParametro('id_agrupador').") ");    
        }
		//I-2000////EGS-I-20/08/2018///
		///parametro que filtra el combo de listar facturas en Sis cobros por tipo de cobro como el de retencion de garantias 
		////los codigos de loss tipos de cobro se usan para el filtro son :
		//cobro comun :CBRCMN
		///cobro comun  regularizado:CBRCMNRE
		/// cobro retencion garantias:CBRCMNRG
		///cobro retencion garantias regularizado : CBRCMNRGRE
		
		#2001  ETR       12/09/2018        EGS
		if($this->objParam->getParametro('tipo_cobro')=='CBRCMN'){
            $this->objParam->addFiltro(" (dcv.id_int_comprobante is not null or pla.tipo_informe = ''regularizacion'') ");    
        }
		#2001  ETR       12/09/2018        EGS
		/*
		if($this->objParam->getParametro('tipo_cobro')=='CBRCMNRE'){
            $this->objParam->addFiltro(" dcv.id_int_comprobante is null");    
        }
       */
		if($this->objParam->getParametro('tipo_cobro')=='CBRCMNRG'){
            $this->objParam->addFiltro("dcv.importe_retgar > 0 and (dcv.id_int_comprobante is not null or pla.tipo_informe = ''regularizacion'')");    
        }
      
		if($this->objParam->getParametro('tipo_cobro')=='CBRCMNRGRE'){
            $this->objParam->addFiltro("dcv.importe_retgar > 0 ");    
        }
		#2001  ETR       12/09/2018        EGS
		if($this->objParam->getParametro('tipo_cobro')=='CBRCMNAT'){
            $this->objParam->addFiltro("dcv.importe_anticipo > 0 and dcv.id_int_comprobante is not null");    
        }
      
		if($this->objParam->getParametro('tipo_cobro')=='CBRCMNATRE'){
            $this->objParam->addFiltro("dcv.importe_anticipo > 0 ");    
        }
		#2001  ETR       12/09/2018        EGS
		//F-2000////EGS-F-20/08/2018///
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocCompraVenta','listarDocCompraVentaCobro');
		} else{
			$this->objFunc=$this->create('MODDocCompraVenta');			
			$this->res=$this->objFunc->listarDocCompraVentaCobro($this->objParam);
		}
		
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}





     //RAC 26/05/2017, para el listado de la grilla con  informacion de agencia
    function listarDocCompraCajero(){
		$this->objParam->defecto('ordenacion','id_doc_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
            $this->objParam->addFiltro("dcv.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));    
        }
		
		if($this->objParam->getParametro('tipo')!=''){
            $this->objParam->addFiltro("dcv.tipo = ''".$this->objParam->getParametro('tipo')."''");    
        }
		
		if($this->objParam->getParametro('sin_cbte')=='si'){
            $this->objParam->addFiltro("dcv.id_int_comprobante is NULL");    
        }
		
		if($this->objParam->getParametro('fecha_cbte')!=''){
            $this->objParam->addFiltro("dcv.fecha <= ''".$this->objParam->getParametro('fecha_cbte')."''::date");    
        }

        if($this->objParam->getParametro('filtro_usuario') == 'si'){
            $this->objParam->addFiltro("dcv.id_usuario_reg = ".$_SESSION["ss_id_usuario"]);
        }
		
		if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }
		
		if($this->objParam->getParametro('id_agrupador')!=''){
            $this->objParam->addFiltro("dcv.id_doc_compra_venta not in (select ad.id_doc_compra_venta from conta.tagrupador_doc ad where ad.id_agrupador = ".$this->objParam->getParametro('id_agrupador').") ");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocCompraVenta','listarDocCompraCajero');
		} else{
			$this->objFunc=$this->create('MODDocCompraVenta');			
			$this->res=$this->objFunc->listarDocCompraCajero($this->objParam);
		}
		
		$temp = Array();
			$temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
			$temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
			$temp['importe_it'] = $this->res->extraData['total_importe_it'];
			$temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
			$temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
			$temp['importe_doc'] = $this->res->extraData['total_importe_doc'];			
			$temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
			$temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
			$temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
			$temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
			$temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
			$temp['importe_pago_liquido'] = $this->res->extraData['total_importe_pago_liquido'];	
			$temp['importe_aux_neto'] = $this->res->extraData['total_importe_aux_neto'];	
					
			$temp['tipo_reg'] = 'summary';
			$temp['id_doc_compra_venta'] = 0;
			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}



	function listarNroAutorizacion(){
		$this->objParam->defecto('ordenacion','nro_autorizacion');
        $this->objParam->defecto('dir_ordenacion','asc');		
		$this->objFunc=$this->create('MODDocCompraVenta');
		$this->res=$this->objFunc->listarNroAutorizacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function listarNroNit(){
		$this->objParam->defecto('ordenacion','nit');
        $this->objParam->defecto('dir_ordenacion','asc');		
		$this->objFunc=$this->create('MODDocCompraVenta');
		$this->res=$this->objFunc->listarNroNit($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDocCompraVenta(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarDocCompraVenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDocCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function modificarBasico(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->modificarBasico($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function obtenerRazonSocialxNIT(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->obtenerRazonSocialxNIT($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	
	/*
	 * Author:  		 RAC - KPLIAN
	 * Date:   			 04/02/2015
	 * Description		 insertar documentos de compra o venta con su detalle de conceptos
	 * */
	
	function insertarDocCompleto(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		if($this->objParam->insertar('id_doc_compra_venta')){			
			$this->res=$this->objFunc->insertarDocCompleto($this->objParam);			
		} else{
			//TODO			
			//$this->res=$this->objFunc->modificarSolicitud($this->objParam);
			//trabajar en la modificacion compelta de solicitud ....
			$this->res=$this->objFunc->modificarDocCompleto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarDocCompletoCajero(){
		$this->objFunc=$this->create('MODDocCompraVenta');
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarDocCompletoCajero($this->objParam);
		} else{
			//TODO
			//$this->res=$this->objFunc->modificarSolicitud($this->objParam);
			//trabajar en la modificacion compelta de solicitud ....
			$this->res=$this->objFunc->modificarDocCompletoCajero($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
		
						
	function eliminarDocCompraVenta(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->eliminarDocCompraVenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function editAplicacion(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->editAplicacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	
	function cambiarRevision(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->cambiarRevision($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function quitarCbteDoc(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->quitarCbteDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function agregarCbteDoc(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->agregarCbteDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	
	function recuperarDatosLCV(){    	
		$this->objFunc = $this->create('MODDocCompraVenta');
		$cbteHeader = $this->objFunc->listarRepLCV($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	function recuperarDatosEntidad(){    	
		$this->objFunc = $this->create('sis_parametros/MODEntidad');
		$cbteHeader = $this->objFunc->getEntidadByDepto($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	function recuperarDatosPeriodo(){    	
		$this->objFunc = $this->create('sis_parametros/MODPeriodo');
		$cbteHeader = $this->objFunc->getPeriodoById($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	
	function reporteLCV(){
		
			
		$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
		$dataSource = $this->recuperarDatosLCV();
		$dataEntidad = $this->recuperarDatosEntidad();
		$dataPeriodo = $this->recuperarDatosPeriodo();
		
		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'L';
		$titulo = 'Consolidado';
		
		
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		//Instancia la clase de pdf
		if($this->objParam->getParametro('tipo')=='compra'){
		   $reporte = new RLcv($this->objParam);  
		}
		else{
			$reporte = new RLcvVentas($this->objParam);  
		} 
         
		$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData, $dataEntidad->getDatos() , $dataPeriodo->getDatos() );
		//$this->objReporteFormato->renderDatos($this->res2->datos);
		
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

    function exportarTxtLcvLCV(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFun=$this->create('MODDocCompraVenta');		
		
		$this->res = $this->objFun->listarRepLCV();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res, $this->objParam);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el archivo LCV'.$nombreArchivo,
										'Se genero con exito el archivo LCV'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacion($res, $Obj) {
		
		/*******************************
		 *  FORMATEA NOMBRE DE ARCHIVO
		 * compras_MMAAAA_NIT.txt     
		 * o    
		 * ventas_MMAAAA_NIT.txt
		 * 
		 * ********************************/
		 
		$dataEntidad = $this->recuperarDatosEntidad();
		$dataEntidadArray = $dataEntidad->getDatos();
		$NIT = 	$dataEntidadArray['nit'];
		
		$dataPeriodo = $this->recuperarDatosPeriodo();
		$dataPeriodoArray = $dataPeriodo->getDatos();
		$sufijo = $dataPeriodoArray['periodo'].$dataPeriodoArray['gestion'];
		
		
		 if($Obj->getParametro('tipo') == 'compra'){
		 	 $nombre = 'compras_'.$sufijo.'_'.$NIT;
		 }
		 else{
		 	 $nombre = 'ventas_'.$sufijo.'_'.$NIT;
		 }
		
		$data = $res -> getDatos();
		$fileName = $nombre.'.txt';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		$ctd = 1;
		
		foreach ($data as $val) {			
			
			 $newDate = date("d/m/Y", strtotime( $val['fecha']));			 
			 if($Obj->getParametro('tipo') == 'compra'){
			 	
					fwrite ($file,  "1|".
				 	                $ctd."|".
			                        $newDate."|".
			                        $val['nit']."|".
			                        $val['razon_social']."|".
			                        $val['nro_documento']."|".
									$val['nro_dui']."|".
			                        $val['nro_autorizacion']."|".
			                        $val['importe_doc']."|".
			                        $val['total_excento']."|".
									$val['subtotal']."|".
									$val['importe_descuento']."|".
									$val['sujeto_cf']."|".
									$val['importe_iva']."|".
									$val['codigo_control']."|".
			                        $val['tipo_doc']."\r\n");
		              			
			 }
			 else{
				 	fwrite ($file,  "3|".
				 	        $ctd."|".
	                        $newDate."|".
	                        $val['nro_documento']."|".
	                        $val['nro_autorizacion']."|".         
							$val['tipo_doc']."|".
	                        $val['nit']."|".        
	                        $val['razon_social']."|".       
	                        $val['importe_doc']."|".
	                        $val['importe_ice']."|".            
	                        $val['importe_excento']."|".
	                        $val['venta_gravada_cero']."|".       
	                        $val['subtotal_venta']."|".     
	                        $val['importe_descuento']."|".      
	                        $val['sujeto_df']."|".     
	                        $val['importe_iva']."|".    
	                        $val['codigo_control']."\r\n");
						
				
			 }
			 
			 	  		
			 $ctd = $ctd + 1;
         } //end for
		
		fclose($file);
		return $fileName;
	}

    //   #1999  relacionas facturas a las notas de credito debito
    function relacionarFacturaNCD(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->relacionarFacturaNCD($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//   #1999  relacionas facturas a las notas de credito debito
    function cargarDatosFactura(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->cargarDatosFactura($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	 function listarContraFactura(){
        $this->objParam->defecto('ordenacion','id_contrato');
        $this->objParam->defecto('dir_ordenacion','asc');
       // var_dump($this->objParam->getParametro('id_contrato'));exit;
        if($this->objParam->getParametro('id_contrato') != '') {
            $this->objParam->addFiltro(" dcv.id_contrato = " . $this->objParam->getParametro('id_contrato'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODDocCompraVenta','listarContraFactura');
        } else{
            $this->objFunc=$this->create('MODDocCompraVenta');

            $this->res=$this->objFunc->listarContraFactura($this->objParam);
        }
        $temp = Array();
        $temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
        $temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
        $temp['importe_it'] = $this->res->extraData['total_importe_it'];
        $temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
        $temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
        $temp['importe_doc'] = $this->res->extraData['total_importe_doc'];
        $temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
        $temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
        $temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
        $temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
        $temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
        $temp['importe_pago_liquido'] = $this->res->extraData['total_importe_pago_liquido'];
        $temp['importe_aux_neto'] = $this->res->extraData['total_importe_aux_neto'];

        $temp['tipo_reg'] = 'summary';
        $temp['id_doc_compra_venta'] = 0;
        
        $this->res->total++;
        $this->res->addLastRecDatos($temp);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarCodigoProveedorFactura(){
        $this->objParam->defecto('ordenacion','id_doc_compra_venta');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('codigo_auxiliar') != '') {
            $this->objParam->addFiltro(" au.codigo_auxiliar = " ."''". $this->objParam->getParametro('codigo_auxiliar')."''");
        }
        $this->objFunc=$this->create('MODDocCompraVenta');
        $this->res=$this->objFunc->listarCodigoProveedorFactura($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarContrato(){
        $this->objFunc=$this->create('MODDocCompraVenta');
        $this->res=$this->objFunc->asignarContrato($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function eleminarContrato(){
        $this->objFunc=$this->create('MODDocCompraVenta');
        $this->res=$this->objFunc->quitarContratoFactura($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	//#112	
	function listarNroTramite(){
		$this->objParam->defecto('ordenacion','nro_autorizacion');
        $this->objParam->defecto('dir_ordenacion','asc');		
		$this->objFunc=$this->create('MODDocCompraVenta');
		$this->res=$this->objFunc->listarNroTramite($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//#112
	function repAutorizacion() {
		$dataSource = new DataSource();	

		if($this->objParam->getParametro('id_depto_conta')!=''){
			$this->objParam->addFiltro("dcv.id_depto_conta =".$this->objParam->getParametro('id_depto_conta'));
		}
		
		if($this->objParam->getParametro('id_periodo')!=''){
			$this->objParam->addFiltro("dcv.id_periodo =".$this->objParam->getParametro('id_periodo'));
		}
		$this->objFun=$this->create('MODDocCompraVenta');	
		$this->res = $this->objFun->repAutorizacion();
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$titulo ='DetalleAutorizacionPasajes';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('datos',$this->res->datos);			
		$this->objReporteFormato=new RepAutorizacion($this->objParam);
	
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());			
	}	
	//#112
	function RepRegPasa() {
		$dataSource = new DataSource();	

		if($this->objParam->getParametro('id_pago_simple')!=''){
			$this->objParam->addFiltro("paside.id_pago_simple =".$this->objParam->getParametro('id_pago_simple'));
		}

		$this->objFun=$this->create('MODDocCompraVenta');	
		$this->res = $this->objFun->RepRegPasa();
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$titulo ='Registro de Pasajeros';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('datos',$this->res->datos);			
		$this->objReporteFormato=new RepRegPasa($this->objParam);
	
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());			
	}
    function reporteRegistroVentas(){ //#113
        $this->objFunc = $this->create('MODDocCompraVenta');
        $this->res = $this->objFunc->reporteRegistroVentas($this->objParam);
        $titulo = 'Registros Vestas';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RReporteRegistrosVentaCC($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
}

?>