<?php
/**
*@package pXP
*@file gen-ACTTransaccionValor.php
*@author  (admin)
*@date 22-07-2013 03:57:28
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTransaccionValor extends ACTbase{    
			
	function listarTransaccionValor(){
		$this->objParam->defecto('ordenacion','id_transaccion_valor');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTransaccionValor','listarTransaccionValor');
		} else{
			$this->objFunc=$this->create('MODTransaccionValor');
			
			$this->res=$this->objFunc->listarTransaccionValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTransaccionValor(){
		$this->objFunc=$this->create('MODTransaccionValor');	
		if($this->objParam->insertar('id_transaccion_valor')){
			$this->res=$this->objFunc->insertarTransaccionValor($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTransaccionValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTransaccionValor(){
			$this->objFunc=$this->create('MODTransaccionValor');	
		$this->res=$this->objFunc->eliminarTransaccionValor($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>