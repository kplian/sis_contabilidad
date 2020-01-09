<?php
/**
*@package pXP
*@file gen-ACTIntComprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
ISSUE     FORK          FECHA:		       AUTOR                 DESCRIPCION
   
 #0        		     29-08-2013        RCM KPLIAN        CREACION
 #2                  27-08-2018        RAC KPLIAN        se añade trasaccion para modicar glosa
 #7      ENDEERT		27-12-2018     MANUEL GUERRA     crearon listado de tramites, y la modifiacion del nrotramite_aux
 #15     ENDEERT		04-01-2019     Miguel Mamani     corrección filtro por gestión interfaz visto bueno comprobantes
 * 1A			21/08/2018		EGS					se creo la funcion listarIntComprobanteCombo
 #55 	ETR			30/05/2019			EGS				 Se agrega funcion par poder migrar comprobantes
#87		  ETR		    08/01/2020	        MMV 		         Reporte Cbte formato Excel

 */
//require_once(dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php');
// convert to PDF
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../../lib/lib_reporte/PlantillasHTML.php');
require_once(dirname(__FILE__).'/../../lib/lib_reporte/smarty/ksmarty.php');
require_once(dirname(__FILE__).'/../reportes/RIntCbte.php');

require_once(dirname(__FILE__).'/../reportes/RComprobanteDiario.php');
require_once(dirname(__FILE__).'/../reportes/RComprobanteDiario_cuad.php');
require_once(dirname(__FILE__).'/../reportes/RComprobanteDiarioXls.php');
require_once(dirname(__FILE__).'/../reportes/RCbteXls.php');
require_once(dirname(__FILE__).'/../reportes/RIntCbteExcel.php');  //#87
//
class ACTIntComprobante extends ACTbase{
	
	private $objPlantHtml;
	
	function listarIntComprobante(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addFiltro("(incbte.temporal = ''no'' or (incbte.temporal = ''si'' and vbregional = ''si''))");    
		
		if($this->objParam->getParametro('id_deptos')!=''){
            $this->objParam->addFiltro("incbte.id_depto in (".$this->objParam->getParametro('id_deptos').")");    
        }
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("incbte.id_gestion in (".$this->objParam->getParametro('id_gestion').")");    
        }
		
		if($this->objParam->getParametro('id_clase_comprobante')!=''){
            $this->objParam->addFiltro("incbte.id_clase_comprobante in (".$this->objParam->getParametro('id_clase_comprobante').")");
        }
		
		if($this->objParam->getParametro('nombreVista') == 'IntComprobanteLd'  || $this->objParam->getParametro('nombreVista') == 'IntComprobanteLdEntrega'){
            $this->objParam->addFiltro("incbte.estado_reg = ''validado''");    
        }
		else{
			$this->objParam->addFiltro("incbte.estado_reg in (''borrador'', ''edicion'')");
		}
		
		if($this->objParam->getParametro('nombreVista') == 'IntComprobanteLdEntrega'){
            $this->objParam->addFiltro(" (incbte.c31 = '''' or incbte.c31 is null )" );      
        }
		
		if($this->objParam->getParametro('momento')!= ''){
			$this->objParam->addFiltro("incbte.momento = ''".$this->objParam->getParametro('momento')."''");    
		}

		//RCM 01/09/2017
		
		if($this->objParam->getParametro('estado_reg_estado')!= ''){
			$this->objParam->addFiltro("incbte.estado_reg = ''".$this->objParam->getParametro('estado_reg_estado')."''");    
		}
		
		if($this->objParam->getParametro('id_int_comprobante')!= ''){
			$this->objParam->addFiltro("incbte.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));    
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarIntComprobante');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarIntComprobante($this->objParam);
		}
		
		//echo dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php';exit;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}




   function listarIntComprobanteWF(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addFiltro("(incbte.temporal = ''no'' or (incbte.temporal = ''si'' and vbregional = ''si''))");    
		
		if($this->objParam->getParametro('id_deptos')!=''){
            $this->objParam->addFiltro("incbte.id_depto in (".$this->objParam->getParametro('id_deptos').")");    
        }
        ////MMV-- #15  --///////
       if($this->objParam->getParametro('id_clase_comprobante')!=''){
           $this->objParam->addFiltro("incbte.id_clase_comprobante in (".$this->objParam->getParametro('id_clase_comprobante').")");
       }
       if($this->objParam->getParametro('id_gestion')!=''){
           $this->objParam->addFiltro("incbte.id_gestion in (".$this->objParam->getParametro('id_gestion').")");
       }
       ////MMV-- #15 --///////
		if($this->objParam->getParametro('momento')!= ''){
			$this->objParam->addFiltro("incbte.momento = ''".$this->objParam->getParametro('momento')."''");    
		}
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarIntComprobanteWF');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarIntComprobanteWF($this->objParam);
		}
		
		//echo dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php';exit;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}





	
	function listarSimpleIntComprobante(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addFiltro("inc.estado_reg = ''validado''");
		
		if($this->objParam->getParametro('id_deptos')!=''){
            $this->objParam->addFiltro("inc.id_depto in (".$this->objParam->getParametro('id_deptos').")");    
        }
        
        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }
		
		 if($this->objParam->getParametro('id_moneda')!=''){
            $this->objParam->addFiltro("inc.id_moneda = ".$this->objParam->getParametro('id_moneda'));    
        }
        
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarSimpleIntComprobante');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarSimpleIntComprobante($this->objParam);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
				
	function insertarIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		if($this->objParam->insertar('id_int_comprobante')){
			$this->res=$this->objFunc->insertarIntComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarIntComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->eliminarIntComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function generarDesdePlantilla(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->generarDesdePlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function validarIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->validarIntComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//Cabecera reporte comprobante
	function listarCbteCabecera(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarCbteCabecera');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			$this->res=$this->objFunc->listarCbteCabecera($this->objParam);
		}

		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//Detalle reporte comprobante
	function listarCbteDetalle(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarCbteDetalle');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			$this->res=$this->objFunc->listarCbteDetalle($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporteComprobante1(){
		$this->objFunc=$this->create('MODIntComprobante');
		
		//
		//Seteo de los parámetros generales del reporte
		//
		//Configuración
		$this->objParam->addParametro('orientation','P');
		$this->objParam->addParametro('unit','mm');
		$this->objParam->addParametro('format','Letter');
		$this->objParam->addParametro('unicode',true);
		$this->objParam->addParametro('encoding','UTF-8');
		$this->objParam->addParametro('diskcache',false);
		$this->objParam->addParametro('pdfa',false);
		//Archivo
		$this->objParam->addParametro('nombre_archivo','pxp_conta_comprobante');
		$this->objParam->addParametro('title1','REGISTRO');
		$this->objParam->addParametro('title2','Comprobante');
		
		$this->objParam->addParametro('header_key_right1','Cbte.');
		$this->objParam->addParametro('header_key_right2','Rev.');
		$this->objParam->addParametro('header_key_right3','Fecha.');
		$this->objParam->addParametro('header_key_right4','Pagina.');
		$this->objParam->addParametro('header_value_right1','DCC-CD-090001/2013');
		$this->objParam->addParametro('header_value_right2','1.0');
		$this->objParam->addParametro('header_value_right3','10/09/2013');
		$this->objParam->addParametro('header_value_right4','12');
		
		//Instancia de las plantillas
		$this->objPlantHtml=new PlantillasHTML($this->objParam);
		$this->objPlantHtml->setSeleccionarPlantilla('header',0);
		$header=$this->objPlantHtml->getPlantilla();
		$this->objPlantHtml->setSeleccionarPlantilla('footer',0);
		$footer=$this->objPlantHtml->getPlantilla();
			
	
		//Instancia la clase de reportes
		$this->objReporte = new ReportePDF2($this->objParam);
		$this->objReporte->setHeaderHtml($header);
		$this->objReporte->setFooterHtml($footer);

		//Genera el reporte		
		$this->objReporte->generarReporte();
		
		//Salida
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$this->objParam->getParametro('nombre_archivo'),'control');
		$mensajeExito->setArchivoGenerado($this->objReporte->getNombreArchivo());
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function reporteComprobante(){
		/////////////////////
		//Obtención de datos
		/////////////////////
		//Cabecera (firmas)
		$this->objFunc=$this->create('MODIntComprobante');
		$cbteHeader = $this->objFunc->listarCbteCabecera($this->objParam);
		$cbteHeaderData=$cbteHeader->getDatos();
		
		//Detalle transacciones
		$this->objFunc=$this->create('MODIntComprobante');
		$cbteTrans = $this->objFunc->listarCbteDetalle($this->objParam);
		$cbteTransData=$cbteTrans->getDatos();
		
		//Se obtienen la suma de debe y haber
		$arrTotalesCbte= array('tot_ejec'=>0,'tot_debe'=>0,'tot_haber'=>0,'tot_debe1'=>0,'tot_haber1'=>0);
		
		foreach($cbteTransData as $key=>$val){
			$arrTotalesCbte['tot_debe']+=$val['importe_debe'];
			$arrTotalesCbte['tot_haber']+=$val['importe_haber'];
			$arrTotalesCbte['tot_debe1']+=$val['importe_debe1'];
			$arrTotalesCbte['tot_haber1']+=$val['importe_haber1'];
		}
		
		/*echo '<pre>';
		print_r($cbteTransData);
		echo '</pre>';
		exit;*/
		
		
		//Reporte
		$repCbte = new ksmarty();
		
		//////////
		//Header
		//////////
		$repCbte->assign('main_title1','COMPROBANTE DIARIO'); //dinámico
		$repCbte->assign('main_title2','MOMENTO PRESUPUESTARIO: DEVENGADO');//dinámico
		$repCbte->assign('header_key_right1','Depto.');
		$repCbte->assign('header_key_right2','N°');
		$repCbte->assign('header_key_right3','Fecha');
		$repCbte->assign('header_value_right1',$cbteHeaderData[0]['cod_depto']);//dinámico
		$repCbte->assign('header_value_right2',$cbteHeaderData[0]['nro_cbte']);//dinámico
		$repCbte->assign('header_value_right3',$cbteHeaderData[0]['fecha']);//dinámico
		$header = $repCbte->fetch($repCbte->getTplHeader());
		
		//echo $header;exit;
		
		/////////
		//Labels
		/////////
		$repCbte->setTemplateDir(dirname(__FILE__).'/../reportes/tpl_comprobante/');
		$labels=$repCbte->fetch('labels.tpl');
		
		
		/////////
		//Footer
		/////////
		$repCbte->setTemplateDir(dirname(__FILE__).'/../reportes/tpl_comprobante/');
		$repCbte->assign('etiqueta1','Centro Responsable');
		$repCbte->assign('etiqueta2','Elaborado por');
		$repCbte->assign('etiqueta3','Beneficiario');
		$repCbte->assign('etiqueta4','VoBo');
		$repCbte->assign('firma1',$cbteHeaderData[0]['firma1']);
		$repCbte->assign('firma2',$cbteHeaderData[0]['firma2']);
		$repCbte->assign('firma3',$cbteHeaderData[0]['firma3']);
		$repCbte->assign('firma4',$cbteHeaderData[0]['firma4']);
		$repCbte->assign('cargo1',$cbteHeaderData[0]['firma1_cargo']);
		$repCbte->assign('cargo2',$cbteHeaderData[0]['firma2_cargo']);
		$repCbte->assign('cargo3',$cbteHeaderData[0]['firma3_cargo']);
		$repCbte->assign('cargo4',$cbteHeaderData[0]['firma4_cargo']);
		$footer = $repCbte->fetch('footer.tpl');
		
		
		//////////
		//Master
		//////////
		$repCbte->setTemplateDir(dirname(__FILE__).'/../reportes/tpl_comprobante/');
		$repCbte->assign('acreedor',$cbteHeaderData[0]['beneficiario']); //dinámico
		$repCbte->assign('conformidad',$cbteHeaderData[0]['glosa1']); //dinámico
		$repCbte->assign('operacion',$cbteHeaderData[0]['glosa2']); //dinámico
		$repCbte->assign('tipo_cambio',$cbteHeaderData[0]['tipo_cambio']); //dinámico
		$repCbte->assign('facturas','Facturas 1 2'); //dinámico
		$repCbte->assign('pedido','Pedido G'); //dinámico
		$repCbte->assign('aprobacion','Aprobación V'); //dinámico
		$master=$repCbte->fetch('master.tpl');
		
		
		/////////
		//Detail
		/////////
		$repCbte->assign('transac',$cbteTransData); //dinámico
		$repCbte->assign('tot_ejecucion_bs',$arrTotalesCbte['tot_ejec']); //dinámico
		$repCbte->assign('tot_importe_debe1',$arrTotalesCbte['tot_debe1']); //dinámico
		$repCbte->assign('tot_importe_haber1',$arrTotalesCbte['tot_haber1']); //dinámico
		$repCbte->assign('tot_importe_debe',$arrTotalesCbte['tot_debe']); //dinámico
		$repCbte->assign('tot_importe_haber',$arrTotalesCbte['tot_haber']); //dinámico
		$detail=$repCbte->fetch('comprobante.tpl');

		
		////////////////////////////
		//Creación del archivo html
		////////////////////////////
		//$html = $header.'<br>'.$master.'<br>'.$labels.'<br>'.$detail.'<br>'.$footer;
		$html = $header.$master.$labels.$detail.$footer;
		//echo 'resp:'.$html; exit;
		
		$repCbte->generarArchivo($html,'pxp_comprobante');
		
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO',dirname(__FILE__),'Salida generada','Se generó la salida HTML con éxito','control','reporteComprobante');
		$mensajeExito->setArchivoGenerado($repCbte->getFileName());
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
		
		//Se obtienen la suma de debe y haber
		$arrTotalesCbte= array('tot_ejec'=>0,'tot_debe'=>0,'tot_haber'=>0,'tot_debe1'=>0,'tot_haber1'=>0);
		
		foreach($cbteTransData as $key=>$val){
			$arrTotalesCbte['tot_debe']+=$val['importe_debe'];
			$arrTotalesCbte['tot_haber']+=$val['importe_haber'];
			$arrTotalesCbte['tot_debe1']+=$val['importe_debe1'];
			$arrTotalesCbte['tot_haber1']+=$val['importe_haber1'];
		}
		
		
	}

    function recuperarDatosCbte(){
    	$dataSource = new DataSource();	
		$this->objFunc = $this->create('MODIntComprobante');
		$cbteHeader = $this->objFunc->listarCbteCabecera($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
				 	
				$dataSource->putParameter('cabecera',$cbteHeader->getDatos());
						
				$this->objFunc=$this->create('MODIntComprobante');
				$cbteTrans = $this->objFunc->listarCbteDetalle($this->objParam);
				if($cbteTrans->getTipo()=='EXITO'){
					$dataSource->putParameter('detalleCbte', $cbteTrans->getDatos());
				}
		        else{
		            $cbteTrans->imprimirRespuesta($cbteTrans->generarJson());
				}
			return $dataSource;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
		}              
		
    }

   function reporteCbte(){
			
		$nombreArchivo = uniqid(md5(session_id()).'-Cbte') . '.pdf'; 
		$dataSource = $this->recuperarDatosCbte();	
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'p';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		
		$reporte = new RIntCbte($this->objParam); 
		
		$reporte->datosHeader($dataSource);
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

    function reporteCbte_bk(){
   	    	
   	    $dataSource = $this->recuperarDatosCbte(); 
   	   	
   	    // get the HTML
	    ob_start();
	    include(dirname(__FILE__).'/../reportes/tpl/intCbte.php');
        $content = ob_get_clean();
	    try
	    {
	    	
			//$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
			$pdf = new TCPDF();
			
			
			$pdf->SetDisplayMode('fullpage');
			
            // set document information
            $pdf->SetCreator(PDF_CREATOR);
			// set default header data
			//$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE.' 061', PDF_HEADER_STRING);
			
			// set default monospaced font
			$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
			
			// set margins
			$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
			$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
			$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
			
			// set auto page breaks
			$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
			
			// set font
			$pdf->SetFont('helvetica', '', 10);
			// add a page
            $pdf->AddPage();
			$pdf->writeHTML($content, true, false, true, false, '');
			$nombreArchivo = 'IntComprobante.pdf';
			$pdf->Output(dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo, 'F');
			
			$mensajeExito = new Mensaje();
            $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->res = $mensajeExito;
            $this->res->imprimirRespuesta($this->res->generarJson());
			
			
			
			
	    }
	    catch(exception $e) {
	        echo $e;
	        exit;
	    }
    }	


    function igualarComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->igualarComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function swEditable(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->swEditable($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function volcarCbte(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->volcarCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarCbteDependencias(){
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_cuenta=$this->objParam->getParametro('id_int_comprobante');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_cuenta);
        }
        
		$this->objFunc=$this->create('MODIntComprobante');
        $this->res=$this->objFunc->listarCbteDependencias();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_int_comprobante'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_int_comprobante_padre'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> (#id_int_comprobante#) - #nro_cbte# </b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'nombre_cuenta'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #nro_cbte#</b><br/>#glosa1#'));
        
        
        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
         
        /*se añade un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */
                                                                

         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
													
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

   }

   function siguienteEstado(){
        $this->objFunc=$this->create('MODIntComprobante');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   function anteriorEstado(){
        $this->objFunc=$this->create('MODIntComprobante');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
   
   function clonarCbte(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->clonarCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
   
   function modificarFechasCostosCbte(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->modificarFechasCostosCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
   
   

   function listarVerPresCbte(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addFiltro("(incbte.temporal = ''no'' or (incbte.temporal = ''si'' and vbregional = ''si''))");    
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarVerPresCbte');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarVerPresCbte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//
	function listarRepIntComprobante(){

		$this->objParam->addFiltro("(incbte.temporal = ''no'' or (incbte.temporal = ''si'' and vbregional = ''si''))");    		
		if($this->objParam->getParametro('id_deptos')!=''){
			$this->objParam->addFiltro("incbte.id_depto in (".$this->objParam->getParametro('id_deptos').")");    
		}		
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("incbte.id_gestion in (".$this->objParam->getParametro('id_gestion').")");    
		}		
		if($this->objParam->getParametro('id_clase_comprobante')!=''){
		    $this->objParam->addFiltro("incbte.id_clase_comprobante in (".$this->objParam->getParametro('id_clase_comprobante').")");    
		}		
		if($this->objParam->getParametro('nombreVista') == 'IntComprobanteLd'  || $this->objParam->getParametro('nombreVista') == 'IntComprobanteLdEntrega'){
			$this->objParam->addFiltro("incbte.estado_reg = ''validado''");    
		}
		else{
			$this->objParam->addFiltro("incbte.estado_reg in (''borrador'', ''edicion'')");
		}		
		if($this->objParam->getParametro('nombreVista') == 'IntComprobanteLdEntrega'){
			$this->objParam->addFiltro(" (incbte.c31 = '''' or incbte.c31 is null )" );      
		}		
		if($this->objParam->getParametro('momento')!= ''){
			$this->objParam->addFiltro("incbte.momento = ''".$this->objParam->getParametro('momento')."''");    
		}
		if($this->objParam->getParametro('id_int_comprobante')!= ''){
			$this->objParam->addFiltro("incbte.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));    
		}

		$this->objFunc=$this->create('MODIntComprobante');		
		$cbteHeader = $this->objFunc->listarRepIntComprobanteDiario($this->objParam);			
		if($cbteHeader->getTipo() == 'EXITO'){										
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}			
	}
	//mp
	function impReporteDiario() {
		if($this->objParam->getParametro('tipo_formato')=='pdf') {
			$nombreArchivo = uniqid(md5(session_id()).'LibroDiario').'.pdf';			
			$dataSource = $this->listarRepIntComprobante();	
			$dataEntidad = "";
			$dataPeriodo = "";	
			$orientacion = 'P';		
			$tamano = 'LETTER';
			$titulo = 'Consolidado';
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);		
			$this->objParam->addParametro('titulo_archivo',$titulo);	
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$reporte = new RComprobanteDiario($this->objParam);  
			$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, '' , '');		
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());		
		}
		if($this->objParam->getParametro('tipo_formato')=='pdf_c') {
			$nombreArchivo = uniqid(md5(session_id()).'LibroDiario').'.pdf';			
			$dataSource = $this->listarRepIntComprobante();	
			$dataEntidad = "";
			$dataPeriodo = "";	
			$orientacion = 'P';		
			$tamano = 'LETTER';
			$titulo = 'Consolidado';
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);		
			$this->objParam->addParametro('titulo_archivo',$titulo);	
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$reporte = new RComprobanteDiario_cuad($this->objParam);  
			$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, '' , '');		
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());		
		}
		if($this->objParam->getParametro('tipo_formato')=='xls') {			
			$this->objFun=$this->create('MODIntComprobante');	
			$this->res = $this->objFun->listarRepIntComprobanteDiario();
			if($this->res->getTipo()=='ERROR'){
				$this->res->imprimirRespuesta($this->res->generarJson());
				exit;
			}
			$titulo ='Diario';
			$nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('datos',$this->res->datos);			
			$this->objReporteFormato=new RComprobanteDiarioXls($this->objParam);
			$this->objReporteFormato->generarDatos();
			$this->objReporteFormato->generarReporte();
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		}				
	}

	function listarIntComprobanteTCCCuenta(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_tipo_cc')!=''){
            $this->objParam->addFiltro("cc.id_tipo_cc =".$this->objParam->getParametro('id_tipo_cc'));    
        }

        if($this->objParam->getParametro('nro_cuenta')!=''){
            $this->objParam->addFiltro("cue.nro_cuenta = ''".$this->objParam->getParametro('nro_cuenta')."''");
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarIntComprobanteTCCCuenta');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarIntComprobanteTCCCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//#2 RAC, 27-08-2018  se añade trasaccion para modificar glosa de comprobantes validados
	function modificarGlosaIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->modificarGlosaIntComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
		////////////EGS-F-21/08/2018///    1A	
	function listarIntComprobanteCombo(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
	
		if($this->objParam->getParametro('estado_reg')!= ''){
			$this->objParam->addFiltro("incbte.estado_reg = ''validado''");    
		}
		/*
		if($this->objParam->getParametro('clase_comprobante')!= ''){
			$this->objParam->addFiltro("clc.movimiento = ''".$this->objParam->getParametro('clase_comprobante')."''");    
		}*/
		
		if($this->objParam->getParametro('clase_comprobante')!= ''){
			$this->objParam->addFiltro("clc.movimiento in(''".$this->objParam->getParametro('clase_comprobante')."'',''".$this->objParam->getParametro('clase_comprobante1')."'')");  
		}
	
		$this->objFunc=$this->create('MODIntComprobante');
			
		$this->res=$this->objFunc->listarIntComprobanteCombo($this->objParam);
		
		
		
		//echo dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php';exit;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
	
	////////////EGS-F-21/08/2018///    1A	
	
	//mp
	function ListadoCbte() {						
		$this->objFun=$this->create('MODIntComprobante');	
		$this->res = $this->objFun->listadoCbtes();
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		$titulo ='Cbtes';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('datos',$this->res->datos);			
		$this->objReporteFormato=new RCbteXls($this->objParam);
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());				
	}
	//#7
	function modificarTramiIntCbte(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->modificarTramiIntCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//#7
	function listadoTramites(){
		$this->objParam->defecto('ordenacion','nro_tramite');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objFunc=$this->create('MODIntComprobante');			
		$this->res=$this->objFunc->listadoTramites($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function migrarComprobante(){//#55

		$this->objFunc=$this->create('MODIntComprobante');			
		$this->res=$this->objFunc->migrarComprobante($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function reporteCbteExcel (){ //#87
        $dataSource = $this->recuperarDatosCbte();
        $nombreArchivo = uniqid(md5(session_id()).'Cbte').'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $reporte = new RIntCbteExcel($this->objParam);
        $reporte->datosHeader($dataSource);
        $reporte->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
	
}

?>