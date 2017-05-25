<?php
/**
*@package pXP
*@file gen-ACTFacturaAirbp.php
*@author  (gsarmiento)
*@date 12-01-2017 21:45:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFacturaAirbp extends ACTbase{    
			
	function listarFacturaAirbp(){
		$this->objParam->defecto('ordenacion','id_factura_airbp');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFacturaAirbp','listarFacturaAirbp');
		} else{
			$this->objFunc=$this->create('MODFacturaAirbp');
			
			$this->res=$this->objFunc->listarFacturaAirbp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFacturaAirbp(){
		$this->objFunc=$this->create('MODFacturaAirbp');	
		if($this->objParam->insertar('id_factura_airbp')){
			$this->res=$this->objFunc->insertarFacturaAirbp($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFacturaAirbp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFacturaAirbp(){
			$this->objFunc=$this->create('MODFacturaAirbp');	
		$this->res=$this->objFunc->eliminarFacturaAirbp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>