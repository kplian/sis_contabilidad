<?php
/**
*@package pXP
*@file gen-ACTResultadoDep.php
*@author  (admin)
*@date 14-07-2015 13:40:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTResultadoDep extends ACTbase{    
			
	function listarResultadoDep(){
		$this->objParam->defecto('ordenacion','id_resultado_dep');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_resultado_plantilla')!=''){
			$this->objParam->addFiltro("resdep.id_resultado_plantilla = ".$this->objParam->getParametro('id_resultado_plantilla'));	
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODResultadoDep','listarResultadoDep');
		} else{
			$this->objFunc=$this->create('MODResultadoDep');
			
			$this->res=$this->objFunc->listarResultadoDep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarResultadoDep(){
		$this->objFunc=$this->create('MODResultadoDep');	
		if($this->objParam->insertar('id_resultado_dep')){
			$this->res=$this->objFunc->insertarResultadoDep($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarResultadoDep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarResultadoDep(){
			$this->objFunc=$this->create('MODResultadoDep');	
		$this->res=$this->objFunc->eliminarResultadoDep($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>