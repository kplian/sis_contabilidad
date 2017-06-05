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
}

?>