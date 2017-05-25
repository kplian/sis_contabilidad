<?php
/**
*@package pXP
*@file gen-ACTBancarizacionGestion.php
*@author  (admin)
*@date 09-02-2017 20:12:18
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTBancarizacionGestion extends ACTbase{    
			
	function listarBancarizacionGestion(){
		$this->objParam->defecto('ordenacion','id_bancarizacion_gestion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODBancarizacionGestion','listarBancarizacionGestion');
		} else{
			$this->objFunc=$this->create('MODBancarizacionGestion');
			
			$this->res=$this->objFunc->listarBancarizacionGestion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarBancarizacionGestion(){
		$this->objFunc=$this->create('MODBancarizacionGestion');	
		if($this->objParam->insertar('id_bancarizacion_gestion')){
			$this->res=$this->objFunc->insertarBancarizacionGestion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarBancarizacionGestion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarBancarizacionGestion(){
			$this->objFunc=$this->create('MODBancarizacionGestion');	
		$this->res=$this->objFunc->eliminarBancarizacionGestion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>