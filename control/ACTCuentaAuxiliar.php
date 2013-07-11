<?php
/**
*@package pXP
*@file gen-ACTCuentaAuxiliar.php
*@author  (admin)
*@date 11-07-2013 20:37:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaAuxiliar extends ACTbase{    
			
	function listarCuentaAuxiliar(){
		$this->objParam->defecto('ordenacion','id_cuenta_auxiliar');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('id_cuenta')!=''){
            $this->objParam->addFiltro("id_cuenta = ".$this->objParam->getParametro('id_cuenta'));    
        }
        
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaAuxiliar','listarCuentaAuxiliar');
		} else{
			$this->objFunc=$this->create('MODCuentaAuxiliar');
			
			$this->res=$this->objFunc->listarCuentaAuxiliar($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaAuxiliar(){
		$this->objFunc=$this->create('MODCuentaAuxiliar');	
		if($this->objParam->insertar('id_cuenta_auxiliar')){
			$this->res=$this->objFunc->insertarCuentaAuxiliar($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaAuxiliar($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaAuxiliar(){
			$this->objFunc=$this->create('MODCuentaAuxiliar');	
		$this->res=$this->objFunc->eliminarCuentaAuxiliar($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>