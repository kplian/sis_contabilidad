<?php
/**
*@package pXP
*@file gen-ACTOficinaOt.php
*@author  (jrivera)
*@date 09-10-2015 18:48:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTOficinaOt extends ACTbase{    
			
	function listarOficinaOt(){
		$this->objParam->defecto('ordenacion','id_oficina_ot');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOficinaOt','listarOficinaOt');
		} else{
			$this->objFunc=$this->create('MODOficinaOt');
			
			$this->res=$this->objFunc->listarOficinaOt($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarOficinaOt(){
		$this->objFunc=$this->create('MODOficinaOt');	
		if($this->objParam->insertar('id_oficina_ot')){
			$this->res=$this->objFunc->insertarOficinaOt($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOficinaOt($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarOficinaOt(){
			$this->objFunc=$this->create('MODOficinaOt');	
		$this->res=$this->objFunc->eliminarOficinaOt($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>