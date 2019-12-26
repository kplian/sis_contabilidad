<?php
/**
*@package pXP
*@file gen-ACTDependenciaAnexos.php
*@author  (miguel.mamani)
*@date 08-08-2019 20:35:20
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDependenciaAnexos extends ACTbase{    
			
	function listarDependenciaAnexos(){
		$this->objParam->defecto('ordenacion','id_dependencia_anexos');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_reporte_anexos') != ''){
            $this->objParam->addFiltro("das.id_reporte_anexos = ".$this->objParam->getParametro('id_reporte_anexos'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDependenciaAnexos','listarDependenciaAnexos');
		} else{
			$this->objFunc=$this->create('MODDependenciaAnexos');
			
			$this->res=$this->objFunc->listarDependenciaAnexos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDependenciaAnexos(){
		$this->objFunc=$this->create('MODDependenciaAnexos');	
		if($this->objParam->insertar('id_dependencia_anexos')){
			$this->res=$this->objFunc->insertarDependenciaAnexos($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDependenciaAnexos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDependenciaAnexos(){
			$this->objFunc=$this->create('MODDependenciaAnexos');	
		$this->res=$this->objFunc->eliminarDependenciaAnexos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>