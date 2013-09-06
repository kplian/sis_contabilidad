<?php
/**
*@package pXP
*@file gen-ACTTransaccion.php
*@author  (admin)
*@date 22-07-2013 03:51:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTransaccion extends ACTbase{    
			
	function listarTransaccion(){
		$this->objParam->defecto('ordenacion','id_transaccion');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_comprobante')!=''){
			$this->objParam->addFiltro("transa.id_comprobante = ".$this->objParam->getParametro('id_comprobante'));	
		}
		if($this->objParam->getParametro('id_moneda')!=''){
			$this->objParam->addFiltro("tval.id_moneda = ".$this->objParam->getParametro('id_moneda'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTransaccion','listarTransaccion');
		} else{
			$this->objFunc=$this->create('MODTransaccion');
			
			$this->res=$this->objFunc->listarTransaccion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTransaccion(){
		$this->objFunc=$this->create('MODTransaccion');	
		if($this->objParam->insertar('id_transaccion')){
			$this->res=$this->objFunc->insertarTransaccion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTransaccion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTransaccion(){
			$this->objFunc=$this->create('MODTransaccion');	
		$this->res=$this->objFunc->eliminarTransaccion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>