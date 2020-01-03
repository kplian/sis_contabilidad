<?php
/**
*@package pXP
*@file gen-ACTDependenciaAnexosDet.php
*@author  (miguel.mamani)
*@date 09-08-2019 13:47:05
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDependenciaAnexosDet extends ACTbase{    
			
	function listarDependenciaAnexosDet(){
		$this->objParam->defecto('ordenacion','id_dependencia_anexos_det');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_dependencia_anexos') != ''){
            $this->objParam->addFiltro("dda.id_dependencia_anexos = ".$this->objParam->getParametro('id_dependencia_anexos'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDependenciaAnexosDet','listarDependenciaAnexosDet');
		} else{
			$this->objFunc=$this->create('MODDependenciaAnexosDet');
			
			$this->res=$this->objFunc->listarDependenciaAnexosDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDependenciaAnexosDet(){
		$this->objFunc=$this->create('MODDependenciaAnexosDet');	
		if($this->objParam->insertar('id_dependencia_anexos_det')){
			$this->res=$this->objFunc->insertarDependenciaAnexosDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDependenciaAnexosDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDependenciaAnexosDet(){
			$this->objFunc=$this->create('MODDependenciaAnexosDet');	
		$this->res=$this->objFunc->eliminarDependenciaAnexosDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>