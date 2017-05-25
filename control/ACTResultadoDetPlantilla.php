<?php
/**
*@package pXP
*@file gen-ACTResultadoDetPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:13:15
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTResultadoDetPlantilla extends ACTbase{    
			
	function listarResultadoDetPlantilla(){
		$this->objParam->defecto('ordenacion','id_resultado_det_plantilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_resultado_plantilla')!=''){
			$this->objParam->addFiltro("resdet.id_resultado_plantilla = ".$this->objParam->getParametro('id_resultado_plantilla'));	
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODResultadoDetPlantilla','listarResultadoDetPlantilla');
		} else{
			$this->objFunc=$this->create('MODResultadoDetPlantilla');
			
			$this->res=$this->objFunc->listarResultadoDetPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarResultadoDetPlantilla(){
		$this->objFunc=$this->create('MODResultadoDetPlantilla');	
		if($this->objParam->insertar('id_resultado_det_plantilla')){
			$this->res=$this->objFunc->insertarResultadoDetPlantilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarResultadoDetPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarResultadoDetPlantilla(){
			$this->objFunc=$this->create('MODResultadoDetPlantilla');	
		$this->res=$this->objFunc->eliminarResultadoDetPlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>