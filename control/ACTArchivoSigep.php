<?php
/**
*@package pXP
*@file gen-ACTArchivoSigep.php
*@author  (gsarmiento)
*@date 10-05-2017 15:38:14
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTArchivoSigep extends ACTbase{    
			
	function listarArchivoSigep(){
		$this->objParam->defecto('ordenacion','id_archivo_sigep');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODArchivoSigep','listarArchivoSigep');
		} else{
			$this->objFunc=$this->create('MODArchivoSigep');
			
			$this->res=$this->objFunc->listarArchivoSigep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarArchivoSigep(){
		$this->objFunc=$this->create('MODArchivoSigep');	
		if($this->objParam->insertar('id_archivo_sigep')){
			$this->res=$this->objFunc->insertarArchivoSigep($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarArchivoSigep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarArchivoSigep(){
			$this->objFunc=$this->create('MODArchivoSigep');	
		$this->res=$this->objFunc->eliminarArchivoSigep($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>