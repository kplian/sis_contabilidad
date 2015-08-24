<?php
/**
*@package pXP
*@file gen-ACTPeriodoCompraVenta.php
*@author  (admin)
*@date 24-08-2015 14:16:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPeriodoCompraVenta extends ACTbase{    
			
	function listarPeriodoCompraVenta(){
		$this->objParam->defecto('ordenacion','id_periodo_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		if($this->objParam->getParametro('id_depto')!=''){
			$this->objParam->addFiltro("pcv.id_depto = ".$this->objParam->getParametro('id_depto'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPeriodoCompraVenta','listarPeriodoCompraVenta');
		} else{
			$this->objFunc=$this->create('MODPeriodoCompraVenta');
			
			$this->res=$this->objFunc->listarPeriodoCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	
						
	function generarPeriodosCompraVenta(){
			$this->objFunc=$this->create('MODPeriodoCompraVenta');	
		    $this->res=$this->objFunc->generarPeriodosCompraVenta($this->objParam);
		    $this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function cerrarAbrirPeriodo(){
			$this->objFunc=$this->create('MODPeriodoCompraVenta');	
		    $this->res=$this->objFunc->cerrarAbrirPeriodo($this->objParam);
		    $this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
			
}

?>