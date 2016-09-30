<table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">
	
<tbody>
	<tr>
		<td style="width: 23%; color: #444444;" rowspan="4">
			&nbsp;<br><img  style="width: 150px;" src="./../../../lib/<?php echo $_SESSION['_DIR_LOGO'];?>" alt="Logo">
		</td>		
		<td style="width: 54%; color: #444444;" rowspan="4"><h1><?php  echo $this->cabecera[0]['desc_clase_comprobante']; ?> </h1></td>
		<td style="width: 23%; color: #444444;"><b>Depto.:</b> <?php  echo $this->cabecera[0]['codigo_depto']; ?> </td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>N°:</b> <?php  echo $this->cabecera[0]['nro_cbte']; ?> </td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>Fecha:</b> <?php  echo $newDate; ?></td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>Moneda</b> <?php  echo $this->cabecera[0]['desc_moneda']; ?> </td>
	</tr>
</tbody>
</table>

<table width="100%" cellpadding="5px"  rules="cols" border="1">
<tbody>	
		<tr>
			<td width="70%"><b>Beneficiario:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['beneficiario']; ?></td>
			<td width="30%"><b>Nro Trámite:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['nro_tramite']; ?></td>
		</tr>
		
		<tr>
			<td><b>Glosa:</b>&nbsp;&nbsp;&nbsp;&nbsp; <?php  echo trim($this->cabecera[0]['glosa1']).'<br>'.trim($this->cabecera[0]['glosa2']); ?></td>
			 <?php 
			  if ($this->cabecera[0]['id_moneda'] != $this->cabecera[0]['id_moneda_base']){
			 ?>
		      <td><b>T/C:</b> &nbsp;&nbsp;&nbsp;&nbsp;<?php  echo $this->cabecera[0]['tipo_cambio']; ?></td>
		    <?php } ?>
		</tr>
</tbody>
</table>
<BR/>
<table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
		
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
		<tr>
			<td width="60%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="40%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
		</tr>
		<tr>
			<td width="20%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="20%" align="center" class="td_currency"><span><b>HABER</b></span></td>
		</tr>
<?php	}
		else{  ?>
		<tr>
			<td width="50%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['codigo_moneda_base']; ?></b></span></td>
		
		</tr>
		<tr>
			<td width="12.5%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>HABER</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>HABER</b></span></td>
		</tr>
			
		<?php } ?>	
</tbody>
</table>

