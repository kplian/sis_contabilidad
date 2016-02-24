<?php
/**
*@package pXP
*@file gen-ACTPlantillaCalculo.php
*@author  (admin)
*@date 28-08-2013 19:01:20
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlantillaCalculo extends ACTbase{    
			
	function listarPlantillaCalculo(){
		$this->objParam->defecto('ordenacion','id_plantilla_calculo');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_plantilla')!=''){
			$this->objParam->addFiltro("placal.id_plantilla = ".$this->objParam->getParametro('id_plantilla'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlantillaCalculo','listarPlantillaCalculo');
		} else{
			$this->objFunc=$this->create('MODPlantillaCalculo');
			
			$this->res=$this->objFunc->listarPlantillaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlantillaCalculo(){
		$this->objFunc=$this->create('MODPlantillaCalculo');	
		if($this->objParam->insertar('id_plantilla_calculo')){
			$this->res=$this->objFunc->insertarPlantillaCalculo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlantillaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlantillaCalculo(){
			$this->objFunc=$this->create('MODPlantillaCalculo');	
		$this->res=$this->objFunc->eliminarPlantillaCalculo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function recuperarDescuentosPlantillaCalculo(){
        $this->objFunc=$this->create('MODPlantillaCalculo');    
        $this->res=$this->objFunc->recuperarDescuentosPlantillaCalculo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function recuperarDetallePlantillaCalculo(){
        $this->objFunc=$this->create('MODPlantillaCalculo');    
        $this->res=$this->objFunc->recuperarDetallePlantillaCalculo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function exportarDatos(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFunProcesoMacro=$this->create('MODPlantillaCalculo');		
		
		$this->res = $this->objFunProcesoMacro->exportarDatos();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacion($res) {
		$data = $res -> getDatos();
		$fileName = uniqid(md5(session_id()).'PlantillaCalculo').'.sql';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		
		$sw_gui = 0;
		$sw_funciones=0;
		$sw_procedimiento=0;
		$sw_rol=0; 
		$sw_rol_pro=0;
		fwrite ($file,"----------------------------------\r\n".
						  "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
						  "---------------------------------\r\n".
						  "\r\n" );
		foreach ($data as $row) {			
			 if ($row['tipo_reg'] == 'plantilla' ) {
			 	
				if ($row['estado_reg'] == 'inactivo') {
					fwrite ($file, 
					"select conta.f_import_tplantilla ('delete','".							 
							$row['desc_plantilla']."',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");
							
						
					
				} else {
					fwrite ($file, 
					 "select conta.f_import_tplantilla ('insert','".
								$row['desc_plantilla']."'," .
						     (is_null($row['sw_tesoro'])?'NULL':"'".$row['sw_tesoro']."'") ."," .
							 (is_null($row['sw_compro'])?'NULL':"'".$row['sw_compro']."'") ."," .
							 (is_null($row['nro_linea'])?'NULL':"'".$row['nro_linea']."'") ."," .
							 (is_null($row['tipo'])?'NULL':"'".$row['tipo']."'") ."," .
							 (is_null($row['sw_monto_excento'])?'NULL':"'".$row['sw_monto_excento']."'") ."," .
							 (is_null($row['sw_descuento'])?'NULL':"'".$row['sw_descuento']."'") ."," .
							 (is_null($row['sw_autorizacion'])?'NULL':"'".$row['sw_autorizacion']."'") ."," .
							 (is_null($row['sw_codigo_control'])?'NULL':"'".$row['sw_codigo_control']."'") ."," .
							 (is_null($row['tipo_plantilla'])?'NULL':"'".$row['tipo_plantilla']."'") ."," .
							 (is_null($row['sw_nro_dui'])?'NULL':"'".$row['sw_nro_dui']."'") ."," .
							 (is_null($row['sw_ic'])?'NULL':"'".$row['sw_ic']."'") ."," .
							 (is_null($row['tipo_excento'])?'NULL':"'".$row['tipo_excento']."'") ."," .
							 (is_null($row['valor_excento'])?'NULL':"'".$row['valor_excento']."'") ."," .
							 (is_null($row['tipo_informe'])?'NULL':"'".$row['tipo_informe']."'").");\r\n");		
							 
							 	
				}
			 } else if ($row['tipo_reg'] == 'plantilla_calculo') {
				if ($row['estado_reg'] == 'inactivo') {
					fwrite ($file, 
					"select conta.f_import_tplantilla_calculo ('delete','".							 
							$row['desc_plantilla']."','".
							$row['descripcion']."',NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");	
							
				} else {
					
					fwrite ($file, 
					 "select conta.f_import_tplantilla_calculo ('insert',".
							 (is_null($row['desc_plantilla'])?'NULL':"'".$row['desc_plantilla']."'") ."," .
							 (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .
							 (is_null($row['prioridad'])?'NULL':"'".$row['prioridad']."'") ."," .
							 (is_null($row['debe_haber'])?'NULL':"'".$row['debe_haber']."'") ."," .
							 (is_null($row['tipo_importe'])?'NULL':"'".$row['tipo_importe']."'") ."," .
							 (is_null($row['codigo_tipo_relacion'])?'NULL':"'".$row['codigo_tipo_relacion']."'") ."," .
							 (is_null($row['importe'])?'NULL':"'".$row['importe']."'") ."," .
							 (is_null($row['importe_presupuesto'])?'NULL':"'".$row['importe_presupuesto']."'") ."," .
							 (is_null($row['descuento'])?'NULL':"'".$row['descuento']."'") .");\r\n");
							 
							 						
				}
			} 
         } //end for
		
		
		return $fileName;
	}
        
			
}

?>