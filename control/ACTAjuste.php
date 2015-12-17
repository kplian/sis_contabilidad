<?php
/**
*@package pXP
*@file gen-ACTAjuste.php
*@author  (admin)
*@date 10-12-2015 15:16:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAjuste extends ACTbase{    
			
	function listarAjuste(){
		$this->objParam->defecto('ordenacion','id_ajuste');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAjuste','listarAjuste');
		} else{
			$this->objFunc=$this->create('MODAjuste');
			
			$this->res=$this->objFunc->listarAjuste($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAjuste(){
		$this->objFunc=$this->create('MODAjuste');	
		if($this->objParam->insertar('id_ajuste')){
			$this->res=$this->objFunc->insertarAjuste($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAjuste($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAjuste(){
			$this->objFunc=$this->create('MODAjuste');	
		$this->res=$this->objFunc->eliminarAjuste($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function generarCbte(){
			$this->objFunc=$this->create('MODAjuste');	
		$this->res=$this->objFunc->generarCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>