<?php
/**
*@package pXP
*@file ACTAuxiliar.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 20:44:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*  	ISUUE			FECHA			AUTHOR 		DESCRIPCION
*   #23           27/12/2018    Miguel Mamani   Reporte Detalle Auxiliares por Cuenta
*
*
*
*/
require_once(dirname(__FILE__).'/../reportes/RAuxilarDetalle.php');#23
class ACTAuxiliar extends ACTbase{    
			
	function listarAuxiliar(){
		$this->objParam->defecto('ordenacion','id_auxiliar');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_cuenta')!=''){
            $this->objParam->addFiltro("auxcta.id_auxiliar IN (select id_auxiliar 
            							from conta.tcuenta_auxiliar where estado_reg = ''activo'' and id_cuenta = ".$this->objParam->getParametro('id_cuenta') . ") ");    
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

    // Realizamos la conexion a la base de datos sql Server  para poder llamar al procedimiento de replicacion.
    function conectar(){
        //var_dump('conectar');exit;
        $conexion = mssql_connect('172.17.45.133', 'Test', 'Boa.2017');

        if (!$conexion) {
            die('Algo fue mal mientras se conectaba a MSSQL');
        }else{
            //echo ('Conectado Correctamente');
            $p_cadena = 'Ejecucion Diaria ERP';
            mssql_select_db('msdb', $conexion);

            $stmt = mssql_init('dbo.sp_start_job', $conexion);
            mssql_bind($stmt, '@job_name', $p_cadena, SQLVARCHAR, false, false, 50);

            mssql_execute($stmt);
            //mssql_free_statement($stmt);
            //echo 'Mensaje:: ';

        }

        mssql_close($conexion);
    }

    function validarAuxiliar(){
        $this->objFunc=$this->create('MODAuxiliar');
        $this->res=$this->objFunc->validarAuxiliar($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    /************I-#23-MMV**************/
    function listarAuxiliarDetalle(){
        $this->objFunc = $this->create('MODAuxiliar');
        $cbteHeader = $this->objFunc->reporteAuxiliarDetalle($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }

    function listarNulosAuxiliares(){
        $this->objFunc = $this->create('MODAuxiliar');
        $cbteHeader = $this->objFunc->reporteNulosAuxiliares($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }
    function reporteAuxiliarDetalle(){
        $dataSource = $this->listarAuxiliarDetalle();
        $dataSourceNull = $this->listarNulosAuxiliares();

        $titulo = 'Auxilarle Detalle';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $reporte = new RAuxilarDetalle($this->objParam);
        $reporte->datosHeader($dataSource->getDatos(),$dataSourceNull->getDatos());
        $reporte->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    /************F-#23-MMV**************/
}

?>