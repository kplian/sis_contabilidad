<?php
/**
*@package pXP
*@file gen-ACTConfigBanca.php
*@author  (admin)
*@date 11-09-2015 16:51:13
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConfigBanca extends ACTbase{    
			
	function listarConfigBanca(){
		$this->objParam->defecto('ordenacion','id_config_banca');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		
		if($this->objParam->getParametro('descripcion')!=''){
			$this->objParam->addFiltro("confba.descripcion = ''".$this->objParam->getParametro('descripcion')."''");
		}
		
		
		if($this->objParam->getParametro('tipo')!=''){
			$this->objParam->addFiltro("confba.tipo = ''".$this->objParam->getParametro('tipo')."''");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConfigBanca','listarConfigBanca');
		} else{
			$this->objFunc=$this->create('MODConfigBanca');
			
			$this->res=$this->objFunc->listarConfigBanca($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConfigBanca(){
		$this->objFunc=$this->create('MODConfigBanca');	
		if($this->objParam->insertar('id_config_banca')){
			$this->res=$this->objFunc->insertarConfigBanca($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConfigBanca($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConfigBanca(){
			$this->objFunc=$this->create('MODConfigBanca');	
		$this->res=$this->objFunc->eliminarConfigBanca($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>