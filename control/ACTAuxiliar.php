<?php
/**
*@package pXP
*@file ACTAuxiliar.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 20:44:52
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAuxiliar extends ACTbase{    
			
	function listarAuxiliar(){
		$this->objParam->defecto('ordenacion','id_auxiliar');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_cuenta')!=''){
            $this->objParam->addFiltro("auxcta.id_auxiliar IN (select id_auxiliar 
            							from conta.tcuenta_auxiliar where id_cuenta = ".$this->objParam->getParametro('id_cuenta') . ") ");    
        }
		
		if($this->objParam->getParametro('corriente')!=''){
            $this->objParam->addFiltro("auxcta.corriente = ''".$this->objParam->getParametro('corriente')."''");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAuxiliar','listarAuxiliar');
		} else{
			$this->objFunc=$this->create('MODAuxiliar');
			
			$this->res=$this->objFunc->listarAuxiliar($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAuxiliar(){
		$this->objFunc=$this->create('MODAuxiliar');	
		if($this->objParam->insertar('id_auxiliar')){
			$this->res=$this->objFunc->insertarAuxiliar($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAuxiliar($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAuxiliar(){
			$this->objFunc=$this->create('MODAuxiliar');	
		$this->res=$this->objFunc->eliminarAuxiliar($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>