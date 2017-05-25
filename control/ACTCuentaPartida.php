<?php
/**
*@package pXP
*@file gen-ACTCuentaPartida.php
*@author  (admin)
*@date 04-05-2017 10:19:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaPartida extends ACTbase{    
			
	function listarCuentaPartida(){
		$this->objParam->defecto('ordenacion','id_cuenta_partida');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta')!=''){
			$this->objParam->addFiltro("cupa.id_cuenta = ".$this->objParam->getParametro('id_cuenta'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaPartida','listarCuentaPartida');
		} else{
			$this->objFunc=$this->create('MODCuentaPartida');
			
			$this->res=$this->objFunc->listarCuentaPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaPartida(){
		$this->objFunc=$this->create('MODCuentaPartida');	
		if($this->objParam->insertar('id_cuenta_partida')){
			$this->res=$this->objFunc->insertarCuentaPartida($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaPartida(){
			$this->objFunc=$this->create('MODCuentaPartida');	
		$this->res=$this->objFunc->eliminarCuentaPartida($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>