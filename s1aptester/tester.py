import socket
import sctp
import time

from pycrate_asn1dir import S1AP
from pycrate_asn1rt.utils import *
from binascii import hexlify, unhexlify


sock = sctp.sctpsocket_tcp(socket.AF_INET)
sock.connect(("192.188.2.2", 36412))

plmnid = b'\x02\xf8\x39' #20893

IEs = []
IEs.append({'id': 8, 'value': ('ENB-UE-S1AP-ID', 1202), 'criticality': 'reject'})
IEs.append({'id': 26, 'value': ('NAS-PDU', unhexlify('0741720bf600f11040000af910512604e060c04000240205d011d1271d8080211001000010810600000000830600000000000d00000a00001000500bf600f110000101c8d595065200f11000015c0a003103e5e0341300f110400011035758a65d0100c1')), 'criticality': 'reject'})
IEs.append({'id': 67, 'value': ('TAI', {'pLMNidentity': plmnid, 'tAC': b'\x00\x01'}), 'criticality': 'reject'})
IEs.append({'id': 100, 'value': ('EUTRAN-CGI', {'cell-ID': (1, 28), 'pLMNidentity': plmnid}), 'criticality': 'ignore'})
IEs.append({'id': 134, 'value': ('RRC-Establishment-Cause', 'highPriorityAccess'), 'criticality': 'ignore'})
val = ('initiatingMessage', {'procedureCode': 12, 'value': ('InitialUEMessage', {'protocolIEs': IEs}), 'criticality': 'ignore'})

PDU = S1AP.S1AP_PDU_Descriptions.S1AP_PDU
PDU.set_val(val)

sock.send(PDU.to_aper())

time.sleep(2)
data = sock.recv(20000)
pdu_r = S1AP.S1AP_PDU_Descriptions.S1AP_PDU
pdu_r.from_aper(data)
print(pdu_r.to_asn1())

sock.close()
