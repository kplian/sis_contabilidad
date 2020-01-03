<?php
/**
*@package pXP
*@file gen-ACTAnexoCabecera.php
*@author  (miguel.mamani)
*@date 21-08-2019 15:03:21
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAnexoCabecera extends ACTbase{    
			
	function listarAnexoCabecera(){
		$this->objParam->defecto('ordenacion','id_anexo_cabecera');
		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_reporte_anexos')!=''){
            $this->objParam->addFiltro("aoa.id_reporte_anexos = ".$this->objParam->getParametro('id_reporte_anexos'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAnexoCabecera','listarAnexoCabecera');
		} else{
			$this->objFunc=$this->create('MODAnexoCabecera');
			
			$this->res=$this->objFunc->listarAnexoCabecera($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAnexoCabecera(){
		$this->objFunc=$this->create('MODAnexoCabecera');	
		if($this->objParam->insertar('id_anexo_cabecera')){
			$this->res=$this->objFunc->insertarAnexoCabecera($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAnexoCabecera($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAnexoCabecera(){
			$this->objFunc=$this->create('MODAnexoCabecera');	
		$this->res=$this->objFunc->eliminarAnexoCabecera($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>