<?php
/**
*@package pXP
*@file gen-ACTPlanPagoDocumentoAirbp.php
*@author  (admin)
*@date 30-01-2017 13:13:21
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlanPagoDocumentoAirbp extends ACTbase{    
			
	function listarPlanPagoDocumentoAirbp(){
		$this->objParam->defecto('ordenacion','id_plan_pago_documento_airbp');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPagoDocumentoAirbp','listarPlanPagoDocumentoAirbp');
		} else{
			$this->objFunc=$this->create('MODPlanPagoDocumentoAirbp');
			
			$this->res=$this->objFunc->listarPlanPagoDocumentoAirbp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlanPagoDocumentoAirbp(){
		$this->objFunc=$this->create('MODPlanPagoDocumentoAirbp');	
		if($this->objParam->insertar('id_plan_pago_documento_airbp')){
			$this->res=$this->objFunc->insertarPlanPagoDocumentoAirbp($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanPagoDocumentoAirbp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanPagoDocumentoAirbp(){
			$this->objFunc=$this->create('MODPlanPagoDocumentoAirbp');	
		$this->res=$this->objFunc->eliminarPlanPagoDocumentoAirbp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function relacionarFacturasAirBP(){
			$this->objFunc=$this->create('MODPlanPagoDocumentoAirbp');
		$this->res=$this->objFunc->relacionarFacturasAirBP($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>