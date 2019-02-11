<?php
/**
*@package pXP
*@file gen-ACTDocCompraVentaForm.php
*@author  (admin)
*@date 18-08-2018 15:57:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RLcv.php');
require_once(dirname(__FILE__).'/../reportes/RLcvVentas.php');
require_once(dirname(__FILE__).'/../reportes/RLcvXls.php');

require_once(dirname(__FILE__).'/../reportes/RComparacionMayorDiario.php');
require_once(dirname(__FILE__).'/../reportes/RComparacionMayorDiarioXls.php');
require_once(dirname(__FILE__).'/../reportes/RCreditoDebitoSobreVentas.php');
//mp 14/08/2018 agregados reportes de venta-compra credito-debito
require_once(dirname(__FILE__).'/../reportes/RVentasCreditoDebito.php');
require_once(dirname(__FILE__).'/../reportes/RComprasCreditoDebito.php');

class ACTDocCompraVentaForm extends ACTbase{    
			
	
	
	
	function recuperarDatosLCV(){    	
	    $this->objFunc = $this->create('MODDocCompraVenta');
		$cbteHeader = $this->objFunc->listarRepLCVForm($this->objParam);
 
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	function recuperarDatosErpEndensisLCV(){    	
		$this->objFunc = $this->create('MODDocCompraVenta');
		$cbteHeader = $this->objFunc->listarRepLCVFormErpEndesis($this->objParam);
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
		$cbteHeader = $this->objFunc->getEntidad($this->objParam);
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
		$var='';
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		if($this->objParam->getParametro('fecha_ini')!='' && $this->objParam->getParametro('fecha_fin')!=''){
			$this->objParam->addFiltro("( dcv.fecha::date  BETWEEN ''%".$this->objParam->getParametro('fecha_ini')."%''::date  and ''%".$this->objParam->getParametro('fecha_fin')."%''::date)");	
		}
		
		if($this->objParam->getParametro('fecha_ini')!='' && $this->objParam->getParametro('fecha_fin')==''){
			$this->objParam->addFiltro("( dcv.fecha::date  >= ''%".$this->objParam->getParametro('fecha_ini')."%''::date)");	
		}
		
		if($this->objParam->getParametro('fecha_ini')=='' && $this->objParam->getParametro('fecha_fin')!=''){
			$this->objParam->addFiltro("( dcv.fecha::date  <= ''%".$this->objParam->getParametro('fecha_fin')."%''::date)");	
		}
		
		if($this->objParam->getParametro('id_periodo')!=''){
			$this->objParam->addFiltro("dcv.id_periodo =".$this->objParam->getParametro('id_periodo'));    
		}
		
		if($this->objParam->getParametro('id_usuario')!= 0){
			$this->objParam->addFiltro("dcv.id_usuario_reg =".$this->objParam->getParametro('id_usuario'));    
		}	
		if($this->objParam->getParametro('formato_reporte')=='pdf'){			
			$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
			//mp 15/082018 no se utiliza 'endesis_erp', basicamente se reestructura 
			/*
			if($this->objParam->getParametro('tipo_lcv')=='endesis_erp'){
				$dataSource = $this->recuperarDatosErpEndensisLCV();
			}else{
				$dataSource = $this->recuperarDatosLCV();
			}
			$dataEntidad = $this->recuperarDatosEntidad();
			$dataPeriodo = $this->recuperarDatosPeriodo();	
			*/			
			//parametros basicos			
			$dataEntidad = $this->recuperarDatosEntidad();
			$dataPeriodo = $this->recuperarDatosPeriodo();
			switch ($this->objParam->getParametro('tipo_lcv')) {
				case 'lcv_compras':
					$dataSource = $this->recuperarDatosLCV();									
					break;
				case 'lcv_ventas':
					$dataSource = $this->recuperarDatosLCV();
					break;
				case 'lbcd':					
					$dataSource = $this->recuperarDatosVentasDebCre();
					break;
				case 'lbcc':
					$dataSource = $this->recuperarDatosComprasDebCre();
					break;			
				default:					
					break;
			}
			
			$tamano = 'LETTER';
			$orientacion = 'L';
			$titulo = 'Consolidado';
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);		
			$this->objParam->addParametro('titulo_archivo',$titulo);
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);	
			//Instancia la clase de pdf
			/*
			if($this->objParam->getParametro('tipo_lcv')=='lcv_compras' || $this->objParam->getParametro('tipo_lcv')=='endesis_erp'){
				$reporte = new RLcv($this->objParam);  
			}
			else{
				if($this->objParam->getParametro('tipo_lcv')=='nota_credito_debito_sobre_ventas'){
					$reporte = new RCreditoDebitoSobreVentas($this->objParam);  
				}else{
					$reporte = new RLcvVentas($this->objParam); 
				}
			}*/	
			//mp 14/08/2018  genera el reporte de acuerdo	
			switch ($this->objParam->getParametro('tipo_lcv')) {
				case 'lcv_compras':
					$reporte = new RLcv($this->objParam);	
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData, $dataEntidad->getDatos() , $dataPeriodo->getDatos() );				
					break;
				case 'lcv_ventas':
					$reporte = new RLcvVentas($this->objParam);	
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData, $dataEntidad->getDatos() , $dataPeriodo->getDatos() );					
					break;
				case 'lbcd':					
					$reporte = new RVentasCreditoDebito($this->objParam);
					$reporte->datosHeader($dataSource->getDatos(), $dataEntidad->getDatos() , $dataPeriodo->getDatos());					
					break;
				case 'lbcc':
					$reporte = new RComprasCreditoDebito($this->objParam);	
					$reporte->datosHeader($dataSource->getDatos(), $dataEntidad->getDatos() , $dataPeriodo->getDatos());				
					break;			
				default:					
					break;
			}
			
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');			
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		}

		if($this->objParam->getParametro('formato_reporte') == 'xls'){

			$this->objFun=$this->create('MODDocCompraVenta');

			if($this->objParam->getParametro('tipo_lcv')=='endesis_erp'){
			    $this->res = $this->objFun->listarRepLCVFormErpEndesis();
			}else{
			    $this->res = $this->objFun->listarRepLCVForm();
			}
			
			if($this->res->getTipo()=='ERROR'){
			    $this->res->imprimirRespuesta($this->res->generarJson());
			    exit;
			}
			if($this->objParam->getParametro('tipo_lcv')=='lcv_compras'){			
				$var = 'COMPRAS';
		    }
		    else{
				$var = 'VENTAS';
		     }
			//obtener titulo de reporte
			$titulo ='Lcv';
			//Genera el nombre del archivo (aleatorio + titulo)
			$nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
			
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('datos',$this->res->datos);
			$this->objParam->addParametro('var',$var);
			//Instancia la clase de excel
			$this->objReporteFormato=new RLcvXls($this->objParam);
			$this->objReporteFormato->generarDatos();
			$this->objReporteFormato->generarReporte();
			
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
			'Se generó con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

		}
		if($this->objParam->getParametro('formato_reporte')!='pdf' && $this->objParam->getParametro('formato_reporte')!='xls'){
			$this->exportarTxtLcvLCV();
		}
		/*else{
			$this->exportarTxtLcvLCV();
		}*/
	}

    function exportarTxtLcvLCV(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFun=$this->create('MODDocCompraVenta');		
		
		if($this->objParam->getParametro('tipo_lcv')=='endesis_erp'){
			$this->res = $this->objFun->listarRepLCVFormErpEndesis();
		}else{
			$this->res = $this->objFun->listarRepLCVForm();
		}
		
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
			
			
		
		
		$separador = '|';
		if($this->objParam->getParametro('formato_reporte') =='txt')
		{
			$separador = "|";
			$ext = '.txt';
		}
		else{
			$separador = ",";
			$ext = '.csv';
		}
		
		
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
		 
		if($this->objParam->getParametro('filtro_sql')=='periodo'){
			$dataPeriodo = $this->recuperarDatosPeriodo();
			$dataPeriodoArray = $dataPeriodo->getDatos();
		    $sufijo = $dataPeriodoArray['periodo'].$dataPeriodoArray['gestion'];
		}
		else{
			$sufijo=$this->objParam->getParametro('fecha_ini').'_'.$this->objParam->getParametro('fecha_fin');
		}
		
		if($this->objParam->getParametro('tipo_lcv')=='lcv_compras' || $this->objParam->getParametro('tipo_lcv')=='endesis_erp'){			
			 $nombre = 'compras_'.$sufijo.'_'.$NIT;
		}
		else{
			 $nombre = 'ventas_'.$sufijo.'_'.$NIT;
		}
		
		$nombre=str_replace("/", "", $nombre);
		
		
		$data = $res -> getDatos();
		$fileName = $nombre.$ext;
		//create file
		$file = fopen("../../../reportes_generados/$fileName","w+");
		$ctd = 1;
		
		if($this->objParam->getParametro('formato_reporte') !='txt'){
			//AÑADE EL BOMM PARA NO TENER PROBLEMAS AL LEER DE APLICACIONES EXTERNAS
		    fwrite($file, pack("CCC",0xef,0xbb,0xbf));
		}
		
		
		
		
		/******************************
		 *  IMPRIME CABECERA PARA CSV
		 *****************************/
		if($this->objParam->getParametro('formato_reporte') !='txt')
		{
			
			if($this->objParam->getParametro('tipo_lcv')=='lcv_compras' || $this->objParam->getParametro('tipo_lcv')=='endesis_erp'){

					if($dataPeriodoArray['gestion']<2017) {
						fwrite($file, "-" . $separador .
								'N#' . $separador .
								'FECHA DE LA FACTURA O DUI' . $separador .
								'NIT PROVEEDOR' . $separador .
								'NOMBRE O RAZON SOCIAL' . $separador .
								'N# de LA FACTURA.' . $separador .
								'N# de DUI' . $separador .
								'N# de AUTORIZACION' . $separador .
								"IMPORTE TOTAL DE LA COMPRA A" . $separador .
								"IMPORTE NO SUJETO A CREDITO FISCAL B" . $separador .
								"SUBTOTAL C = A - B" . $separador .
								"DESCUENTOS BONOS Y REBAJAS  D" . $separador .
								"IMPORTE SUJETO a CREDITO FISCAL E = C-D" . $separador .
								"CREDITO FISCAL F = E*13%" . $separador .
								'CODIGO DE CONTROL' . $separador .
								'TIPO DE COMPRA' . $separador .
								'#_CBTE' . $separador .
								'ID_CBTE' . $separador .
								'USUARIO' . "\r\n");
					}else{
						fwrite($file, "-" . $separador .
								'N#' . $separador .
								'FECHA DE LA FACTURA O DUI' . $separador .
								'NIT PROVEEDOR' . $separador .
								'NOMBRE O RAZON SOCIAL' . $separador .
								'N# de LA FACTURA.' . $separador .
								'N# de DUI' . $separador .
								'N# de AUTORIZACION' . $separador .
								"IMPORTE TOTAL DE LA COMPRA A" . $separador .
								"IMPORTE NO SUJETO A CREDITO FISCAL B" . $separador .
								"SUBTOTAL C = A - B" . $separador .
								"DESCUENTOS BONOS Y REBAJAS SUJETAS AL IVA D" . $separador .
								"IMPORTE SUJETO a CREDITO FISCAL E = C-D" . $separador .
								"CREDITO FISCAL F = E*13%" . $separador .
								'CODIGO DE CONTROL' . $separador .
								'TIPO DE COMPRA' . $separador .
								'#_CBTE' . $separador .
								'ID_CBTE' . $separador .
								'USUARIO' . "\r\n");
					}
									
			 }
			 else{
				 	fwrite ($file,  "-".$separador.
				 	        'N#'.$separador.
	                        'FECHA DE LA FACTURA'.$separador.
	                        'N# de LA FACTURA'.$separador.
	                        'N# de AUTORIZACION'.$separador.        
							'ESTADO'.$separador.
	                        'NIT CLIENTE'.$separador.      
	                        'NOMBRE O RAZON SOCIAL'.$separador.      
	                        "IMPORTE TOTAL DE LA VENTA A".$separador.
	                        "IMPORTE ICE/ IEHD/ TASAS B".$separador.          
	                        "EXPORTACIO. Y OPERACIONES EXENTAS C".$separador.
	                        "VENTAS GRAVADAS TASA CERO D".$separador.    
	                        "SUBTOTAL E = A-B-C-D".$separador.  
	                        "DESCUENTOS BONOS Y REBAJAS OTORGADAS F".$separador.     
	                        "IMPORTE BASE DEBITO FISCAL G = E-F".$separador.   
	                        "DEBITO FISCAL H = G*13%".$separador.   
	                        'CODIGO DE CONTROL'."\r\n");
				 }
		}
		
		/**************************
		 *  IMPRIME CUERPO
		 **************************/
		
		foreach ($data as $val) {			
			
			 $newDate = date("d/m/Y", strtotime( $val['fecha']));			 
			 if($this->objParam->getParametro('tipo_lcv')=='lcv_compras' || $this->objParam->getParametro('tipo_lcv')=='endesis_erp'){
						
                    $codContro='0';
                    if(trim($val['codigo_control'])!=''||trim($val['codigo_control'])!=null){	
                    	$codContro=$val['codigo_control'];
                    }

					if(trim($val['codigo_moneda'])!='BS'){	
						fwrite ($file,  "1".$separador.
					 	                $ctd.$separador.
				                        $newDate.$separador.
				                        $val['nit'].$separador.
				                        $val['razon_social'].$separador. 
				                        $val['nro_documento'].$separador.
										$val['nro_dui'].$separador.
				                        $val['nro_autorizacion'].$separador.
				                        ($val['importe_doc'] * $val['tipo_cambio']).$separador.
				                        ($val['total_excento'] * $val['tipo_cambio']).$separador.
										($val['subtotal'] * $val['tipo_cambio']).$separador.
										($val['importe_descuento'] * $val['tipo_cambio']).$separador.
										($val['sujeto_cf'] * $val['tipo_cambio']).$separador.
										($val['importe_iva'] * $val['tipo_cambio']).$separador.
										$codContro.$separador.
										$val['tipo_doc'].$separador.
										$val['nro_cbte'].$separador.
										$val['id_int_comprobante'].$separador.
				                        $val['cuenta']."\r\n");
										
					}
					else{
						fwrite ($file,  "1".$separador.
					 	                $ctd.$separador.
				                        $newDate.$separador.
				                        $val['nit'].$separador.
				                        $val['razon_social'].$separador. 
				                        $val['nro_documento'].$separador.
										$val['nro_dui'].$separador.
				                        $val['nro_autorizacion'].$separador.
				                        $val['importe_doc'].$separador.
				                        $val['total_excento'].$separador.
										$val['subtotal'].$separador.
										$val['importe_descuento'].$separador.
										$val['sujeto_cf'].$separador.
										$val['importe_iva'].$separador.
										$codContro.$separador.
					                    $val['tipo_doc'].$separador.
					                    $val['nro_cbte'].$separador.
										$val['id_int_comprobante'].$separador.
				                        $val['cuenta']."\r\n");
					}   			
			 }
			 else{
				 	fwrite ($file,  "3".$separador.
				 	        $ctd.$separador.
	                        $newDate.$separador.
	                        $val['nro_documento'].$separador.
	                        $val['nro_autorizacion'].$separador.        
							$val['tipo_doc'].$separador.
	                        $val['nit'].$separador.      
	                        $val['razon_social'].$separador.	                            
	                        $val['importe_doc'].$separador.
	                        $val['importe_ice'].$separador.          
	                        $val['importe_excento'].$separador.
	                        $val['venta_gravada_cero'].$separador.    
	                        $val['subtotal_venta'].$separador.  
	                        $val['importe_descuento'].$separador.     
	                        $val['sujeto_df'].$separador.   
	                        $val['importe_iva'].$separador.   
	                        $val['codigo_control']."\r\n");		
	                        
	                  				
				
			 }
			 
			 	  		
			 $ctd = $ctd + 1;
         } //end for
         
     
				
		fclose($file);
		return $fileName;
	}

	function recuperarDatosComparacion(){    	
	    $this->objFunc = $this->create('MODDocCompraVenta');
		$cbteHeader = $this->objFunc->reporteComparacion($this->objParam);
 
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	function reporteComparacion(){
		
		$var='';
		if($this->objParam->getParametro('formato_reporte')=='pdf'){
			
			$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
			if($this->objParam->getParametro('tipo_repo')=='endesis_erp'){
				$dataSource = $this->recuperarDatosErpEndensisLCV();
			}else{
				$dataSource = $this->recuperarDatosComparacion();
			}
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
		    if($this->objParam->getParametro('tipo_repo')=='lcv_compras_vs_libro_mayor'){
			
		       $reporte = new RComparacionMayorDiario($this->objParam);  
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

		if($this->objParam->getParametro('formato_reporte') == 'xls'){

		    $this->objFun=$this->create('MODDocCompraVenta');

            if($this->objParam->getParametro('tipo_repo')=='endesis_erp'){
                $this->res = $this->objFun->listarRepLCVFormErpEndesis();
            }else{
                //$this->res = $this->objFun->RComparacionMayorDiarioXls();
				$this->res = $this->objFun->reporteComparacion();
            }

            if($this->res->getTipo()=='ERROR'){
                $this->res->imprimirRespuesta($this->res->generarJson());
                exit;
            }
			if($this->objParam->getParametro('tipo_lcv')=='lcv_compras'){			
				$var = 'COMPRAS';
		    }
		    else{
				$var = 'VENTAS';
		     }
            //obtener titulo de reporte
            $titulo ='Lcv';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';

            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('datos',$this->res->datos);
			$this->objParam->addParametro('var',$var);
            //Instancia la clase de excel
            $this->objReporteFormato=new RComparacionMayorDiarioXls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();

            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

        }  if($this->objParam->getParametro('formato_reporte')!='pdf' && $this->objParam->getParametro('formato_reporte')!='xls'){
            $this->exportarTxtLcvLCV();
        }
        /*else{
			$this->exportarTxtLcvLCV();
		}*/
	}
	//mp
	function recuperarDatosVentasDebCre(){
		$this->objFunc = $this->create('MODDocCompraVenta');
		$cbteHeader = $this->objFunc->recuperarDatosVentasDebCre($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	function recuperarDatosComprasDebCre(){
		$this->objFunc = $this->create('MODDocCompraVenta');
		$cbteHeader = $this->objFunc->recuperarDatosComprasDebCre($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	
	
			
}

?>