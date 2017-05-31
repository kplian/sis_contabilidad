<?php
/**
*@package pXP
*@file gen-ACTPersonaNaturales.php
*@author  (admin)
*@date 31-05-2017 20:17:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPersonaNaturales extends ACTbase{    
			
	function listarPersonaNaturales(){
		$this->objParam->defecto('ordenacion','id_persona_natural');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPersonaNaturales','listarPersonaNaturales');
		} else{
			$this->objFunc=$this->create('MODPersonaNaturales');
			
			$this->res=$this->objFunc->listarPersonaNaturales($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPersonaNaturales(){
		$this->objFunc=$this->create('MODPersonaNaturales');	
		if($this->objParam->insertar('id_persona_natural')){
			$this->res=$this->objFunc->insertarPersonaNaturales($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPersonaNaturales($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPersonaNaturales(){
			$this->objFunc=$this->create('MODPersonaNaturales');	
		$this->res=$this->objFunc->eliminarPersonaNaturales($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>