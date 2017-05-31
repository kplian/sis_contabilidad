<?php
/**
*@package pXP
*@file gen-ACTBancarizacionPeriodo.php
*@author  (favio.figueroa)
*@date 24-05-2017 16:07:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTBancarizacionPeriodo extends ACTbase{    
			
	function listarBancarizacionPeriodo(){
		$this->objParam->defecto('ordenacion','id_bancarizacion_periodo');

		$this->objParam->defecto('dir_ordenacion','asc');


        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("ges.id_gestion = ''".$this->objParam->getParametro('id_gestion')."''");
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODBancarizacionPeriodo','listarBancarizacionPeriodo');
		} else{
			$this->objFunc=$this->create('MODBancarizacionPeriodo');
			
			$this->res=$this->objFunc->listarBancarizacionPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarBancarizacionPeriodo(){
		$this->objFunc=$this->create('MODBancarizacionPeriodo');	
		if($this->objParam->insertar('id_bancarizacion_periodo')){
			$this->res=$this->objFunc->insertarBancarizacionPeriodo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarBancarizacionPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarBancarizacionPeriodo(){
			$this->objFunc=$this->create('MODBancarizacionPeriodo');	
		$this->res=$this->objFunc->eliminarBancarizacionPeriodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>