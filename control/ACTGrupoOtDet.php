<?php
/**
*@package pXP
*@file gen-ACTGrupoOtDet.php
*@author  (admin)
*@date 06-10-2014 14:44:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTGrupoOtDet extends ACTbase{    
			
	function listarGrupoOtDet(){
		$this->objParam->defecto('ordenacion','id_grupo_ot_det');
		
		 if($this->objParam->getParametro('id_grupo_ot')!=''){
	    	$this->objParam->addFiltro("gotd.id_grupo_ot = ".$this->objParam->getParametro('id_grupo_ot'));	
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODGrupoOtDet','listarGrupoOtDet');
		} else{
			$this->objFunc=$this->create('MODGrupoOtDet');
			
			$this->res=$this->objFunc->listarGrupoOtDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarGrupoOtDet(){
		$this->objFunc=$this->create('MODGrupoOtDet');	
		if($this->objParam->insertar('id_grupo_ot_det')){
			$this->res=$this->objFunc->insertarGrupoOtDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarGrupoOtDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarGrupoOtDet(){
			$this->objFunc=$this->create('MODGrupoOtDet');	
		$this->res=$this->objFunc->eliminarGrupoOtDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>