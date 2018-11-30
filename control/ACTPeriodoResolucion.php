<?php
/**
*@package pXP
*@file gen-ACTPeriodoResolucion.php
*@author  (miguel.mamani)
*@date 27-06-2017 21:35:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPeriodoResolucion extends ACTbase{    
			
	function listarPeriodoResolucion(){
		$this->objParam->defecto('ordenacion','id_periodo_resolucion');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("pe.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }

        if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro("prn.id_depto = ".$this->objParam->getParametro('id_depto'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPeriodoResolucion','listarPeriodoResolucion');
		} else{
			$this->objFunc=$this->create('MODPeriodoResolucion');
			
			$this->res=$this->objFunc->listarPeriodoResolucion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function generarPeriodosCompraVenta(){
        $this->objFunc=$this->create('MODPeriodoResolucion');
        $this->res=$this->objFunc->generarPeriodosCompraVenta($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function cerrarAbrirPeriodo(){
        $this->objFunc=$this->create('MODPeriodoResolucion');
        $this->res=$this->objFunc->cerrarAbrirPeriodo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }


}

?>