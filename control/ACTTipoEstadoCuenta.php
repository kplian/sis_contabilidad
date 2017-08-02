<?php
/**
*@package pXP
*@file gen-ACTTipoEstadoCuenta.php
*@author  (admin)
*@date 26-07-2017 21:48:36
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoEstadoCuenta extends ACTbase{    
			
	function listarTipoEstadoCuenta(){
		$this->objParam->defecto('ordenacion','id_tipo_estado_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoEstadoCuenta','listarTipoEstadoCuenta');
		} else{
			$this->objFunc=$this->create('MODTipoEstadoCuenta');
			
			$this->res=$this->objFunc->listarTipoEstadoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarEstadoCuenta(){
		$this->objParam->defecto('ordenacion','id_tipo_estado_columna');
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoEstadoCuenta','listarEstadoCuenta');
		} else{
			$this->objFunc=$this->create('MODTipoEstadoCuenta');
			
			$this->res=$this->objFunc->listarEstadoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
			
	function insertarTipoEstadoCuenta(){
		$this->objFunc=$this->create('MODTipoEstadoCuenta');	
		if($this->objParam->insertar('id_tipo_estado_cuenta')){
			$this->res=$this->objFunc->insertarTipoEstadoCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoEstadoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoEstadoCuenta(){
			$this->objFunc=$this->create('MODTipoEstadoCuenta');	
		$this->res=$this->objFunc->eliminarTipoEstadoCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>