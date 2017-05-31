<?php
/**
*@package pXP
*@file gen-ACTSuborden.php
*@author  (admin)
*@date 15-05-2017 09:57:38
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSuborden extends ACTbase{    
			
	function listarSuborden(){
		$this->objParam->defecto('ordenacion','id_suborden');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSuborden','listarSuborden');
		} else{
			$this->objFunc=$this->create('MODSuborden');
			
			$this->res=$this->objFunc->listarSuborden($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSuborden(){
		$this->objFunc=$this->create('MODSuborden');	
		if($this->objParam->insertar('id_suborden')){
			$this->res=$this->objFunc->insertarSuborden($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSuborden($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSuborden(){
			$this->objFunc=$this->create('MODSuborden');	
		$this->res=$this->objFunc->eliminarSuborden($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>