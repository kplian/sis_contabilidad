<?php
/**
*@package pXP
*@file gen-ACTDocRetencionForm.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RRetencion.php');
require_once(dirname(__FILE__).'/../reportes/RetXls.php');


 
class ACTDocRetencionForm extends ACTbase{
	//
	function recuperarDatosRet(){	
		$this->objFunc = $this->create('MODDocRetencion');
		$cbteHeader = $this->objFunc->listarRetForm($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	//
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
	//
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
	//
	function reporteRET() {
		//var_dump($this->objParam->getParametro('formato_reporte'));		
		//////EGS-I////
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
		//var_dump($this->objParam);  
		//////EGS-F/////////	
		if($this->objParam->getParametro('formato_reporte')=='pdf') {			
			$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 			
			if($this->objParam->getParametro('tipo_ret')=='todo'){
				$orientacion = 'L';
			}else{
				$orientacion = 'P';
			}		
			/////EGS-I//////
			if($this->objParam->getParametro('tipo_ret') =='INVOICE (EXTERIOR - IUE/BE)'){	
				$dataSource = $this->recuperarDatosInvoiceIUE();
				$tamano = 'LETTER';
				$titulo = 'Consolidado';
				$this->objParam->addParametro('orientacion',$orientacion);
				$this->objParam->addParametro('tamano',$tamano);		
				$this->objParam->addParametro('titulo_archivo',$titulo);	
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				$reporte = new Rinvoice($this->objParam);  
				$reporte->datosHeader($dataSource->getDatos());
				$reporte->generarReporte($dataSource->getDatos());
				$reporte->output($reporte->url_archivo,'F');
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con exito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
			}
			else{
				if($this->objParam->getParametro('tipo_ret') =='lbcd'){
					$dataSource = $this->recuperarDatosVentasDebCre();
					$dataEntidad = $this->recuperarDatosEntidad();
					$dataPeriodo = $this->recuperarDatosPeriodo();	
					$tamano = 'LETTER';
					$titulo = 'Consolidado';
					$this->objParam->addParametro('orientacion',$orientacion);
					$this->objParam->addParametro('tamano',$tamano);		
					$this->objParam->addParametro('titulo_archivo',$titulo);	
					$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
					$reporte = new RVentasCreditoDebito($this->objParam);  
					$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, $dataEntidad->getDatos(),$dataPeriodo->getDatos());
					$reporte->generarReporte($dataSource->getDatos());
					$reporte->output($reporte->url_archivo,'F');
					$this->mensajeExito=new Mensaje();
					$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con exito el reporte: '.$nombreArchivo,'control');
					$this->mensajeExito->setArchivoGenerado($nombreArchivo);
					$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
				}				
				else{
					if($this->objParam->getParametro('tipo_ret') =='lbcc'){
						$dataSource = $this->recuperarDatosComprasDebCre();
						$dataEntidad = $this->recuperarDatosEntidad();
						$dataPeriodo = $this->recuperarDatosPeriodo();	
						$tamano = 'LETTER';
						$titulo = 'Consolidado';
						$this->objParam->addParametro('orientacion',$orientacion);
						$this->objParam->addParametro('tamano',$tamano);		
						$this->objParam->addParametro('titulo_archivo',$titulo);	
						$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
						$reporte = new RComprasCreditoDebito($this->objParam);  
						$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, $dataEntidad->getDatos(),$dataPeriodo->getDatos());
						$reporte->generarReporte($dataSource->getDatos());
						$reporte->output($reporte->url_archivo,'F');
						$this->mensajeExito=new Mensaje();
						$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con exito el reporte: '.$nombreArchivo,'control');
						$this->mensajeExito->setArchivoGenerado($nombreArchivo);
						$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
					}	
					else{																					
						$dataSource = $this->recuperarDatosRet();
						$dataEntidad = $this->recuperarDatosEntidad();
						$dataPeriodo = $this->recuperarDatosPeriodo();	
						$tamano = 'LETTER';
						$titulo = 'Consolidado';
						$this->objParam->addParametro('orientacion',$orientacion);
						$this->objParam->addParametro('tamano',$tamano);		
						$this->objParam->addParametro('titulo_archivo',$titulo);	
						$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
						$reporte = new RRetencion($this->objParam);  
						$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, $dataEntidad->getDatos(),$dataPeriodo->getDatos());
						$reporte->generarReporte();
						$reporte->output($reporte->url_archivo,'F');
						$this->mensajeExito=new Mensaje();
						$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con exito el reporte: '.$nombreArchivo,'control');
						$this->mensajeExito->setArchivoGenerado($nombreArchivo);
						$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
					}	
				}
			}			
		}
		//
		if($this->objParam->getParametro('formato_reporte') == 'xls'){							
			if($this->objParam->getParametro('tipo_ret') =='INVOICE (EXTERIOR - IUE/BE)'){				
				$this->objFun=$this->create('MODDocRetencion');
				//
				$this->res = $this->objFun->listarInvoiceIUE();			
				//
				if($this->res->getTipo()=='ERROR'){
					$this->res->imprimirRespuesta($this->res->generarJson());
					exit;
				}
				$titulo ='Invoice';
				$nombreArchivo=uniqid(md5(session_id()).$titulo);
				$nombreArchivo.='.xls';
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				$this->objParam->addParametro('datos',$this->res->datos);			
				$this->objReporteFormato=new RinvoiceXls($this->objParam);
				$this->objReporteFormato->generarDatos();
				$this->objReporteFormato->generarReporte();
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
			}
			
			else{
				$this->objFun=$this->create('MODDocRetencion');
				//
				$this->res = $this->objFun->listarRetForm();
				//
				if($this->res->getTipo()=='ERROR'){
					$this->res->imprimirRespuesta($this->res->generarJson());
					exit;
				}
				$titulo ='Ret';
				$nombreArchivo=uniqid(md5(session_id()).$titulo);
				$nombreArchivo.='.xls';
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				$this->objParam->addParametro('datos',$this->res->datos);
				$this->objReporteFormato=new RetXls($this->objParam);			
				$this->objReporteFormato->generarDatos();
				$this->objReporteFormato->generarReporte();
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());			
			}			
		}
		///////EGS-F/////
		//
		if($this->objParam->getParametro('formato_reporte') == 'txt'){
			$this->objFun=$this->create('MODDocRetencion');
			$this->res = $this->objFun->listarRetForm();
			if($this->res->getTipo()=='ERROR'){
				$this->res->imprimirRespuesta($this->res->generarJson());
				exit;
			}
			$nombreArchivo = $this->crearArchivoExportacion($this->res, $this->objParam);
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el archivo LCV'.$nombreArchivo,'Se genero con exito el archivo LCV'.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->res->imprimirRespuesta($this->mensajeExito->generarJson());
		}
	}
	//
	function crearArchivoExportacion($res, $Obj) {
		$separador = '|';
		if($this->objParam->getParametro('formato_reporte') == 'txt')
		{
			$separador = "|";
			$ext = '.txt';
		}
		//
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
		$nombre=str_replace("/", "", $nombre);
		$data = $res -> getDatos();
		$fileName = $nombre.$ext;
		$file = fopen("../../../reportes_generados/$fileName","w+");
		$ctd = 1;		

		foreach ($data as $val) {			
			$newDate = date("d/m/Y", strtotime( $val['fecha']));			 			
			fwrite ($file,"1".$separador.
							$ctd.$separador.
							$newDate.$separador.
							$val['obs'].$separador.													
							$val['nro_documento'].$separador.
							$val['plantilla'].$separador.			
							$val['importe_doc'].$separador.
							$val['it_total'].$separador.								
							$val['iue_iva_total'].$separador.
							$val['importe_descuento_ley'].$separador.
							$val['descuento'].$separador.								
							$val['liquido']."\r\n");
			 
			$ctd = $ctd + 1;
		}
		fclose($file);
		return $fileName;
	}
}
?>
