<?php
/**
*@package pXP
*@file gen-ACTConfigTipoCuenta.php
*@author  (admin)
*@date 26-02-2013 19:19:24
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConfigTipoCuenta extends ACTbase{    
			
	function listarConfigTipoCuenta(){
		$this->objParam->defecto('ordenacion','id_cofig_tipo_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConfigTipoCuenta','listarConfigTipoCuenta');
		} else{
			$this->objFunc=$this->create('MODConfigTipoCuenta');
			
			$this->res=$this->objFunc->listarConfigTipoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConfigTipoCuenta(){
		$this->objFunc=$this->create('MODConfigTipoCuenta');	
		if($this->objParam->insertar('id_cofig_tipo_cuenta')){
			$this->res=$this->objFunc->insertarConfigTipoCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConfigTipoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConfigTipoCuenta(){
			$this->objFunc=$this->create('MODConfigTipoCuenta');	
		$this->res=$this->objFunc->eliminarConfigTipoCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>