<font size="8"><table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">	
<tbody>
	<tr>
		<td style="width: 23%; color: #444444;" rowspan="4">
			&nbsp;<br><img  style="width: 150px; height: 68px;" src="./../../../lib/<?php echo $_SESSION['_DIR_LOGO'];?>" alt="Logo">
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
</table></font>
