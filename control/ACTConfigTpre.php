<?php
/**
*@package pXP
*@file gen-ACTConfigTpre.php
*@author  (mguerra)
*@date 18-03-2019 16:32:29
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*issue #54	
*/

class ACTConfigTpre extends ACTbase{    
			
	function listarConfigTpre(){
		$this->objParam->defecto('ordenacion','id_conf_pre');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConfigTpre','listarConfigTpre');
		} else{
			$this->objFunc=$this->create('MODConfigTpre');
			
			$this->res=$this->objFunc->listarConfigTpre($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConfigTpre(){
		$this->objFunc=$this->create('MODConfigTpre');	
		if($this->objParam->insertar('id_conf_pre')){
			$this->res=$this->objFunc->insertarConfigTpre($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConfigTpre($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConfigTpre(){
			$this->objFunc=$this->create('MODConfigTpre');	
		$this->res=$this->objFunc->eliminarConfigTpre($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>