<?php
/**
*@package pXP
*@file gen-ACTFacturaAirbpConcepto.php
*@author  (gsarmiento)
*@date 12-01-2017 21:46:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFacturaAirbpConcepto extends ACTbase{    
			
	function listarFacturaAirbpConcepto(){
		$this->objParam->defecto('ordenacion','id_factura_airbp_concepto');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFacturaAirbpConcepto','listarFacturaAirbpConcepto');
		} else{
			$this->objFunc=$this->create('MODFacturaAirbpConcepto');
			
			$this->res=$this->objFunc->listarFacturaAirbpConcepto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFacturaAirbpConcepto(){
		$this->objFunc=$this->create('MODFacturaAirbpConcepto');	
		if($this->objParam->insertar('id_factura_airbp_concepto')){
			$this->res=$this->objFunc->insertarFacturaAirbpConcepto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFacturaAirbpConcepto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFacturaAirbpConcepto(){
			$this->objFunc=$this->create('MODFacturaAirbpConcepto');	
		$this->res=$this->objFunc->eliminarFacturaAirbpConcepto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>