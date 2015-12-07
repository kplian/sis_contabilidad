<?php
/**
*@package pXP
*@file gen-ACTTxtImportacionBcv.php
*@author  (admin)
*@date 03-12-2015 16:57:22
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTxtImportacionBcv extends ACTbase{    
			
	function listarTxtImportacionBcv(){
		$this->objParam->defecto('ordenacion','id_txt_importacion_bcv');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTxtImportacionBcv','listarTxtImportacionBcv');
		} else{
			$this->objFunc=$this->create('MODTxtImportacionBcv');
			
			$this->res=$this->objFunc->listarTxtImportacionBcv($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTxtImportacionBcv(){
		$this->objFunc=$this->create('MODTxtImportacionBcv');	
		if($this->objParam->insertar('id_txt_importacion_bcv')){
			$this->res=$this->objFunc->insertarTxtImportacionBcv($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTxtImportacionBcv($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTxtImportacionBcv(){
			$this->objFunc=$this->create('MODTxtImportacionBcv');	
		$this->res=$this->objFunc->eliminarTxtImportacionBcv($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>