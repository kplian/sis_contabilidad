<?php
/**
*@package pXP
*@file gen-ACTReporteAnexosDet.php
*@author  (miguel.mamani)
*@date 10-06-2019 21:31:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTReporteAnexosDet extends ACTbase{    
			
	function listarReporteAnexosDet(){
		$this->objParam->defecto('ordenacion','id_reporte_anexos_det');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_reporte_anexos') != ''){
            $this->objParam->addFiltro("rad.id_reporte_anexos = ".$this->objParam->getParametro('id_reporte_anexos'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODReporteAnexosDet','listarReporteAnexosDet');
		} else{
			$this->objFunc=$this->create('MODReporteAnexosDet');
			
			$this->res=$this->objFunc->listarReporteAnexosDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarReporteAnexosDet(){
		$this->objFunc=$this->create('MODReporteAnexosDet');	
		if($this->objParam->insertar('id_reporte_anexos_det')){
			$this->res=$this->objFunc->insertarReporteAnexosDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarReporteAnexosDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarReporteAnexosDet(){
			$this->objFunc=$this->create('MODReporteAnexosDet');	
		$this->res=$this->objFunc->eliminarReporteAnexosDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>