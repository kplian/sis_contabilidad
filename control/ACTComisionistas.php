<?php
/**
*@package pXP
*@file gen-ACTComisionistas.php
*@author  (admin)
*@date 31-05-2017 20:17:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTComisionistas extends ACTbase{    
			
	function listarComisionistas(){
		$this->objParam->defecto('ordenacion','id_comisionista');
		$this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_periodo') != ''){
            $this->objParam->addFiltro("cm.id_periodo = ".$this->objParam->getParametro('id_periodo'));
        }
        if($this->objParam->getParametro('id_depto')!=''){
            if($this->objParam->getParametro('id_depto')!=0)
                $this->objParam->addFiltro("cm.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComisionistas','listarComisionistas');
		} else{
			$this->objFunc=$this->create('MODComisionistas');
			
			$this->res=$this->objFunc->listarComisionistas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComisionistas(){
		$this->objFunc=$this->create('MODComisionistas');	
		if($this->objParam->insertar('id_comisionista')){
			$this->res=$this->objFunc->insertarComisionistas($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComisionistas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComisionistas(){
			$this->objFunc=$this->create('MODComisionistas');	
		$this->res=$this->objFunc->eliminarComisionistas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function cambiarRevision(){
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->cambiarRevision($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
    function exporta_txt(){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");

        $this->objFunc2=$this->create('MODComisionistas');
        $this->res2=$this->objFunc2->listarPeriodoGestion($this->objParam);
        $periodo_gestion = $this->res2;
        $periodo = $periodo_gestion[0]['periodo'];
        $gestion = $periodo_gestion[0]['gestion'];
        if($periodo < 10){
            $periodo = "0".$periodo;
        }

        $this->objParam->defecto('ordenacion','id_periodo');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_periodo') != '' &&  $this->objParam->getParametro('gestion') == ''){
            $this->objParam->addFiltro("cm.id_periodo = ''".$this->objParam->getParametro('id_periodo')."'' ");
            $this->objParam->addFiltro("cm.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
            $mmaaaa = $periodo.$gestion;

        }
        if($this->objParam->getParametro('gestion') != ''){
            $this->objParam->addFiltro("ges.gestion = ''".$gestion."'' and cm.id_depto_conta = ''".$this->objParam->getParametro('id_depto')."'' ");
            $mmaaaa = $gestion;
        }
        $this->objParam->addFiltro("cm.revisado = ''si'' ");
        $nit_empresa = $this->nitEmpresa();
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->listarComisionistas($this->objParam);
        $datos = $this->res->getDatos();
        $MiDocumento = fopen("../../../reportes_generados/"."COMISIONISTAS_".$mmaaaa.'_'.$nit_empresa.".txt", "w+");
        $nombre_archivo = "COMISIONISTAS_".$mmaaaa.'_'.$nit_empresa;

        foreach ($datos as $dato) {
            $Escribo = "".  $dato['nit_comisionista'] ."|"
                .$dato['nro_contrato'] ."|"
                .$dato['codigo_producto'] ."|"
                .$dato['descripcion_producto'] ."|"
                .$dato['cantidad_total_entregado'] ."|"
                .$dato['cantidad_total_vendido']."|"
                .$dato['precio_unitario']."|"
                .$dato['monto_total']."|"
                .$dato['monto_total_comision']."|"
               ;

            fwrite($MiDocumento, $Escribo);
            fwrite($MiDocumento, chr(13).chr(10)); //genera el salto de linea
        }
        fclose($MiDocumento);

        $this->res->setDatos($nombre_archivo);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function importar_txt (){
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->importar_txt($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function BorrarTodo(){
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->BorrarTodo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function clonar(){
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->clonar($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function agregarListarNegra(){
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->agregarListarNegra($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function  nitEmpresa(){
        $this->objFunc2=$this->create('MODComisionistas');
        $this->res2=$this->objFunc2->nitEmpresa($this->objParam);
        $empresa = $this->res2;
        $nit_empresa = $empresa[0]['nit'];
        return $nit_empresa;
    }
			
}

?>