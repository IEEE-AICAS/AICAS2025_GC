# 待修改指标
class Mode:
    SINGLE = "Idc"
    IS_SINGLE = False
Gain_min = 60   #dB
GBW_min = 20    #MHz
PM_min = 60     #deg
SR_min = 60     #V/us
Idc_max = 500   #uA


VDD = 1.8       #V
VSS = 0         #V
VCM = 0.9       #V
WL_max = 200    #um^2
L_LVT_min = 0.42 #um

# 创建一个全局的MOSFET字典，key为name，value为MOSFET实例,为了提高访问速度
mosfet_dict = {}
# 创建全局的CurrentSource字典
current_source_dict = {}
# 定义NMOS和PMOS的属性
class MOSFETParam:
    def __init__(self, L, W, W_scale:list=[], nf:int = 1, m:int = 1):
        self.L = L
        self.W = W
        self.W_scale = W_scale
        self.nf = nf
        self.m = m

    def __str__(self):
        return f"L={self.L}, W={self.W}, W_scale={self.W_scale}, nf={self.nf}, m={self.m}"


class MOSFETNet:
    def __init__(self,drain:str,gate:str,source:str,bulk:str):
        self.d = drain
        self.g = gate
        self.s = source
        self.b = bulk
    
    def __str__(self):
        return f"d={self.d}, g={self.g}, s={self.s}, b={self.b}"

class MOSFETCalc:
    def __init__(self, Vgs: float = 0, Vds: float = 0, gmid: float = 0, idW: float = 0, ids: float = 0):
        self.Vgs = Vgs
        self.Vds = Vds
        self.gmid = gmid
        self.idW = idW
        self.ids = ids

    def __str__(self):
        return f"Vgs={self.Vgs}, Vds={self.Vds}, gmid={self.gmid}, idW={self.idW}, ids={self.ids}"


class MOSFET:
    def __init__(self,name:str,type:str,net:MOSFETNet,param:MOSFETParam,calc_param:MOSFETCalc):
        self.name = name
        self.type = type
        self.net = net
        self.param = param
        self.calc_param = calc_param

    def __str__(self):
        return f"name={self.name}, type={self.type}, net={self.net}, param:{self.param}, calc_param:{self.calc_param}"

    def update_param(self, attr_name, attr_value,*args):
        """根据参数名更新MOSFET的相应参数"""
        valid_param_attributes = ['L', 'W', 'nf', 'm']
        valid_voltage_attributes = ['Vgs', 'Vds','gmid','idW','ids']
        if attr_name == "W_scale":
            if len(args) != 1:
                raise ValueError("W_scale需要一个位置参数")
            else:
                self.param.W_scale[args[0]] = attr_value
        elif attr_name in valid_param_attributes:
            setattr(self.param, attr_name, attr_value)
        elif attr_name in valid_voltage_attributes:
            setattr(self.calc_param, attr_name, attr_value)
        else:
            raise ValueError(f"无效的属性名，必须是其中之一: {', '.join(valid_param_attributes + valid_voltage_attributes)}")

    def get_param(self, attr_name):
        """获取指定的MOSFET参数"""
        if attr_name in ['name', 'type']:
            return getattr(self, attr_name)
        if attr_name in ['L', 'W', 'W_scale', 'nf', 'm']:
            return getattr(self.param, attr_name)
        elif attr_name in ['Vgs', 'Vds','gmid','idW','ids']:
            return getattr(self.calc_param, attr_name)
        else:
            raise ValueError("无效的属性名，必须是'param'或'voltage'中的一个")
    
class CurrentNet:
    def __init__(self, pos: str, neg: str):
        self.pos = pos
        self.neg = neg

    def __str__(self):
        return f"pos={self.pos}, neg={self.neg}"

class CurrentSource:
    def __init__(self, name: str, net: CurrentNet, dc: float):
        self.name = name
        self.net = net
        self.dc = dc

    def update_dc(self, dc: float):
        self.dc = dc
    
    def get_dc(self):
        return self.dc

    def __str__(self):
        return f"name={self.name}, net={self.net}, dc={self.dc}"


if __name__ == "__main__":
    mosfet = MOSFET("XM1","nmos",MOSFETNet("d","g","s","b"),MOSFETParam(0.2,0.2),MOSFETCalc(0,0,0,0,0))
    print(mosfet.get_param("type"))

