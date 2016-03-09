<?php
/**
*@package pXP
*@file gen-ACTDocCompraVenta.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RLcv.php');
require_once(dirname(__FILE__).'/../reportes/RLcvVentas.php');

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
		
		
		if($this->objParam->getParametro('formato_reporte')=='pdf'){
			
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
		    if($this->objParam->getParametro('tipo_lcv')=='lcv_compras'){
			
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
		else{
			$this->exportarTxtLcvLCV();
		}
	}

    function exportarTxtLcvLCV(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFun=$this->create('MODDocCompraVenta');		
		
		$this->res = $this->objFun->listarRepLCVForm();
		
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
		$data = $res -> getDatos();
		$fileName = 'LCV-'.$Obj->getParametro('tipo').'.txt';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		$ctd = 1;
		
		foreach ($data as $val) {			
			
			 $newDate = date("d/m/Y", strtotime( $val['fecha']));			 
			 if($this->objParam->getParametro('tipo_lcv')=='lcv_compras'){
			 	
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
		
		
		return $fileName;
	}
	
	
	
			
}

?>