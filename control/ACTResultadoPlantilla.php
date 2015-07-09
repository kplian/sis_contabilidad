<?php
/**
*@package pXP
*@file gen-ACTResultadoPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:12:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTResultadoPlantilla extends ACTbase{    
			
	function listarResultadoPlantilla(){
		$this->objParam->defecto('ordenacion','id_resultado_plantilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODResultadoPlantilla','listarResultadoPlantilla');
		} else{
			$this->objFunc=$this->create('MODResultadoPlantilla');
			
			$this->res=$this->objFunc->listarResultadoPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarResultadoPlantilla(){
		$this->objFunc=$this->create('MODResultadoPlantilla');	
		if($this->objParam->insertar('id_resultado_plantilla')){
			$this->res=$this->objFunc->insertarResultadoPlantilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarResultadoPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarResultadoPlantilla(){
			$this->objFunc=$this->create('MODResultadoPlantilla');	
		$this->res=$this->objFunc->eliminarResultadoPlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>