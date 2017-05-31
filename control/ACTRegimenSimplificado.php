<?php
/**
*@package pXP
*@file gen-ACTRegimenSimplificado.php
*@author  (admin)
*@date 31-05-2017 20:17:05
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRegimenSimplificado extends ACTbase{    
			
	function listarRegimenSimplificado(){
		$this->objParam->defecto('ordenacion','id_simplificado');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRegimenSimplificado','listarRegimenSimplificado');
		} else{
			$this->objFunc=$this->create('MODRegimenSimplificado');
			
			$this->res=$this->objFunc->listarRegimenSimplificado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRegimenSimplificado(){
		$this->objFunc=$this->create('MODRegimenSimplificado');	
		if($this->objParam->insertar('id_simplificado')){
			$this->res=$this->objFunc->insertarRegimenSimplificado($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRegimenSimplificado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRegimenSimplificado(){
			$this->objFunc=$this->create('MODRegimenSimplificado');	
		$this->res=$this->objFunc->eliminarRegimenSimplificado($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>