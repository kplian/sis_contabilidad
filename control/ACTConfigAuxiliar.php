<?php
/**
*@package pXP
*@file gen-ACTConfigAuxiliar.php
*@author  (egutierrez)
*@date 05-06-2019 15:37:13
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConfigAuxiliar extends ACTbase{    
			
	function listarConfigAuxiliar(){
		$this->objParam->defecto('ordenacion','id_config_auxiliar');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConfigAuxiliar','listarConfigAuxiliar');
		} else{
			$this->objFunc=$this->create('MODConfigAuxiliar');
			
			$this->res=$this->objFunc->listarConfigAuxiliar($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConfigAuxiliar(){
		$this->objFunc=$this->create('MODConfigAuxiliar');	
		if($this->objParam->insertar('id_config_auxiliar')){
			$this->res=$this->objFunc->insertarConfigAuxiliar($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConfigAuxiliar($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConfigAuxiliar(){
			$this->objFunc=$this->create('MODConfigAuxiliar');	
		$this->res=$this->objFunc->eliminarConfigAuxiliar($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>