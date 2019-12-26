<?php
/**
*@package pXP
*@file gen-ACTReporteAnexos.php
*@author  (miguel.mamani)
*@date 10-06-2019 21:31:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RReportesAnexosPlan.php');
class ACTReporteAnexos extends ACTbase{    
			
	function listarReporteAnexos(){
		$this->objParam->defecto('ordenacion','id_reporte_anexos');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_gestion') != ''){
            $this->objParam->addFiltro("ras.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODReporteAnexos','listarReporteAnexos');
		} else{
			$this->objFunc=$this->create('MODReporteAnexos');
			
			$this->res=$this->objFunc->listarReporteAnexos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarReporteAnexos(){
		$this->objFunc=$this->create('MODReporteAnexos');	
		if($this->objParam->insertar('id_reporte_anexos')){
			$this->res=$this->objFunc->insertarReporteAnexos($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarReporteAnexos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarReporteAnexos(){
			$this->objFunc=$this->create('MODReporteAnexos');	
		$this->res=$this->objFunc->eliminarReporteAnexos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function resultadoReporte(){
        $this->objFunc = $this->create('MODReporteAnexos');
        $cbteHeader = $this->objFunc->ReporteAnexosPlantillas($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }
    function desgrosarReporte(){
        $this->objFunc = $this->create('MODReporteAnexos');
        $cbteHeader = $this->objFunc->DesgrosarAnexosPlantillas($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }
    function ReporteAnexosPlantillas(){
        $dataSource = $this->resultadoReporte();
        $dataSourceDesgrosar = $this->desgrosarReporte();

        $nombreArchivo = uniqid(md5(session_id()).'Reportes').'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $reporte = new RReportesAnexosPlan($this->objParam);
        $reporte->datosHeader($dataSource->getDatos(),
                             $dataSourceDesgrosar->getDatos());
        $reporte->generarDatos();
        $reporte->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
}

?>