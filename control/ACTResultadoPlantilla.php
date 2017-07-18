<?php
/**
*@package pXP
*@file gen-ACTResultadoPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:12:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
class ACTResultadoPlantilla extends ACTbase{    
			
	function listarResultadoPlantilla(){
		$this->objParam->defecto('ordenacion','id_resultado_plantilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipo')!=''){
			$this->objParam->addFiltro("resplan.tipo = ''".$this->objParam->getParametro('tipo')."''");	
		}
		
		if($this->objParam->getParametro('periodo')=='cbte'){
			$this->objParam->addFiltro("resplan.periodo_calculo = ''cbte''");	
		}
		
		if($this->objParam->getParametro('periodo')=='rangos'){
			$this->objParam->addFiltro("resplan.periodo_calculo  != ''cbte''");	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODResultadoPlantilla','listarResultadoPlantilla');
		} else{
			$this->objFunc=$this->create('MODResultadoPlantilla');
			
			$this->res=$this->objFunc->listarResultadoPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarResultadoPlantilla(){
		$this->objFunc=$this->create('MODResultadoPlantilla');	
		if($this->objParam->insertar('id_resultado_plantilla')){
			$this->res=$this->objFunc->insertarResultadoPlantilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarResultadoPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarResultadoPlantilla(){
		$this->objFunc=$this->create('MODResultadoPlantilla');	
		$this->res=$this->objFunc->eliminarResultadoPlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function clonarPlantilla(){
		$this->objFunc=$this->create('MODResultadoPlantilla');	
		$this->res=$this->objFunc->clonarPlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function exportarDatos(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFunc=$this->create('MODResultadoPlantilla');		
		
		$this->res = $this->objFunc->exportarDatos();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res);
		
		$this->mensajeExito = new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacion($res) {
		$data = $res -> getDatos();
		$fileName = uniqid(md5(session_id()).'ResultadoPlantilla').'.sql';
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
			 if ($row['tipo_reg'] == 'maestro' ) {
			 							
					fwrite ($file, 
					 "select conta.f_import_tresultado_plantilla ('insert','".
								$row['codigo']."'," .
						    (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .
							 (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
							 (is_null($row['tipo'])?'NULL':"'".$row['tipo']."'") ."," .							 
							 (is_null($row['cbte_aitb'])?'NULL':"'".$row['cbte_aitb']."'") ."," .		 
							 (is_null($row['cbte_apertura'])?'NULL':"'".$row['cbte_apertura']."'") ."," .							 
							 (is_null($row['cbte_cierre'])?'NULL':"'".$row['cbte_cierre']."'") ."," .							 
							 (is_null($row['periodo_calculo'])?'NULL':"'".$row['periodo_calculo']."'") ."," .							 
							 (is_null($row['glosa'])?'NULL':"'".$row['glosa']."'") ."," .
							 (is_null($row['codigo_clase_comprobante'])?'NULL':"'".$row['codigo_clase_comprobante']."'") ."," .	
							 (is_null($row['relacion_unica'])?'NULL':"'".$row['relacion_unica']."'") ."," .								 
							 (is_null($row['codigo_tipo_relacion_comprobante'])?'NULL':"'".$row['codigo_tipo_relacion_comprobante']."'") ."," .	
							 (is_null($row['nombre_func'])?'NULL':"'".$row['nombre_func']."'").");\r\n");			
							 	
				
			 } else if ($row['tipo_reg'] == 'detalle') {
				
					
					fwrite ($file, 
					 "select conta.f_import_tresultado_det_plantilla ('insert',".
							 (is_null($row['orden'])?'NULL':"'".$row['orden']."'") ."," .
							 (is_null($row['font_size'])?'NULL':"'".$row['font_size']."'") ."," .
							 (is_null($row['formula'])?'NULL':"'".$row['formula']."'") ."," .
							 (is_null($row['subrayar'])?'NULL':"'".$row['subrayar']."'") ."," .
							 (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
							 (is_null($row['montopos'])?'NULL':"'".$row['montopos']."'") ."," .
							 (is_null($row['nombre_variable'])?'NULL':"'".$row['nombre_variable']."'") ."," .
							 (is_null($row['posicion'])?'NULL':"'".$row['posicion']."'") ."," .
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .
							 (is_null($row['nivel_detalle'])?'NULL':"'".$row['nivel_detalle']."'") ."," .
							 (is_null($row['origen'])?'NULL':"'".$row['origen']."'") ."," .
							 (is_null($row['signo'])?'NULL':"'".$row['signo']."'") ."," .
							 (is_null($row['codigo_cuenta'])?'NULL':"'".$row['codigo_cuenta']."'") ."," .
							 (is_null($row['visible'])?'NULL':"'".$row['visible']."'") ."," .
							 (is_null($row['incluir_apertura'])?'NULL':"'".$row['incluir_apertura']."'") ."," .
							 (is_null($row['incluir_cierre'])?'NULL':"'".$row['incluir_cierre']."'") ."," .
							 (is_null($row['desc_cuenta'])?'NULL':"'".$row['desc_cuenta']."'") ."," .
							 (is_null($row['negrita'])?'NULL':"'".$row['negrita']."'") ."," .
							 (is_null($row['cursiva'])?'NULL':"'".$row['cursiva']."'") ."," .
							 (is_null($row['espacio_previo'])?'NULL':"'".$row['espacio_previo']."'") ."," .
							 (is_null($row['incluir_aitb'])?'NULL':"'".$row['incluir_aitb']."'") ."," .
							 (is_null($row['tipo_saldo'])?'NULL':"'".$row['tipo_saldo']."'") ."," .
							 (is_null($row['signo_balance'])?'NULL':"'".$row['signo_balance']."'") ."," .
							 (is_null($row['relacion_contable'])?'NULL':"'".$row['relacion_contable']."'") ."," .
							 (is_null($row['codigo_partida'])?'NULL':"'".$row['codigo_partida']."'") ."," .
							 (is_null($row['destino'])?'NULL':"'".$row['destino']."'") ."," .
							 (is_null($row['orden_cbte'])?'NULL':"'".$row['orden_cbte']."'") ."," .
							 (is_null($row['codigo_auxiliar'])?'NULL':"'".$row['ocodigo_auxiliarrden_cbte']."'") ."," .
							 (is_null($row['codigo_resultado_plantilla'])?'NULL':"'".$row['codigo_resultado_plantilla']."'") .");\r\n");
							 
						
							 
							 						
				
			} else if ($row['tipo_reg'] == 'dependencia') {
				
					fwrite ($file, 
					 "select conta.f_import_tresultado_dep ('insert',".
					         (is_null($row['codigo_resultado_plantilla_padre'])?'NULL':"'".$row['codigo_resultado_plantilla_padre']."'") ."," .
							 (is_null($row['obs'])?'NULL':"'".$row['obs']."'") ."," .
							 (is_null($row['prioridad'])?'NULL':"'".$row['prioridad']."'") ."," .
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .
							 (is_null($row['codigo_resultado_plantilla'])?'NULL':"'".$row['codigo_resultado_plantilla']."'") .");\r\n");
							 
							 						
				
			} 
         } //end for
		
		
		return $fileName;
	}
			
}

?>