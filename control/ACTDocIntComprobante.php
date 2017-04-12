<?php
/**
*@package pXP
*@file gen-ACTDocIntComprobante.php
*@author  (gsarmiento)
*@date 13-03-2017 15:41:29
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RDocumentoComprobanteXls.php');

class ACTDocIntComprobante extends ACTbase{
			
	function listarDocIntComprobante(){
		$this->objParam->defecto('ordenacion','id_doc_int_comprobante');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocIntComprobante','listarDocIntComprobante');
		} else{
			$this->objFunc=$this->create('MODDocIntComprobante');
			
			$this->res=$this->objFunc->listarDocIntComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDocIntComprobante(){
		$this->objFunc=$this->create('MODDocIntComprobante');	
		if($this->objParam->insertar('id_doc_int_comprobante')){
			$this->res=$this->objFunc->insertarDocIntComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDocIntComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDocIntComprobante(){
			$this->objFunc=$this->create('MODDocIntComprobante');	
		$this->res=$this->objFunc->eliminarDocIntComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function recuperarDocCompraIntComprobante(){
		$this->objFunc = $this->create('MODDocIntComprobante');
		$cbteHeader = $this->objFunc->listarDocCompraVentaIntComprobante($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}

	}

	function reporteDocCompraIntComprobante(){

		$nombreArchivo = 'DocumentoComprobante'.uniqid(md5(session_id())).'.xls';

		$dataSource = $this->recuperarDocCompraIntComprobante();

		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'L';
		$titulo = 'Consolidado';

		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);
		$this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);

		$reporte = new RDocumentoComprobanteXls($this->objParam);
		$reporte->datosHeader($dataSource->getDatos());
		$reporte->generarReporte();

		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

	}
			
}

?>