<?php
/**
*@package pXP
*@file gen-ACTConfigCambiaria.php
*@author  (admin)
*@date 04-11-2015 12:39:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConfigCambiaria extends ACTbase{    
			
	function listarConfigCambiaria(){
		$this->objParam->defecto('ordenacion','id_config_cambiaria');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConfigCambiaria','listarConfigCambiaria');
		} else{
			$this->objFunc=$this->create('MODConfigCambiaria');
			
			$this->res=$this->objFunc->listarConfigCambiaria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConfigCambiaria(){
		$this->objFunc=$this->create('MODConfigCambiaria');	
		if($this->objParam->insertar('id_config_cambiaria')){
			$this->res=$this->objFunc->insertarConfigCambiaria($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConfigCambiaria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConfigCambiaria(){
		$this->objFunc=$this->create('MODConfigCambiaria');	
		$this->res=$this->objFunc->eliminarConfigCambiaria($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function getConfigCambiaria(){
		$this->objFunc=$this->create('MODConfigCambiaria');	
		$this->res=$this->objFunc->getConfigCambiaria($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>