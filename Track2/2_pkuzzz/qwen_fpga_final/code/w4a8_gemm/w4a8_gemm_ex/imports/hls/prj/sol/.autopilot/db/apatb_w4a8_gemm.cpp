#include <systemc>
#include <iostream>
#include <cstdlib>
#include <cstddef>
#include <stdint.h>
#include "SysCFileHandler.h"
#include "ap_int.h"
#include "ap_fixed.h"
#include <complex>
#include <stdbool.h>
#include "autopilot_cbe.h"
#include "hls_stream.h"
#include "hls_half.h"
#include "hls_signal_handler.h"

using namespace std;
using namespace sc_core;
using namespace sc_dt;

// wrapc file define:
#define AUTOTB_TVIN_scalar00 "../tv/cdatafile/c.w4a8_gemm.autotvin_scalar00.dat"
#define AUTOTB_TVOUT_scalar00 "../tv/cdatafile/c.w4a8_gemm.autotvout_scalar00.dat"
#define AUTOTB_TVIN_scalar01 "../tv/cdatafile/c.w4a8_gemm.autotvin_scalar01.dat"
#define AUTOTB_TVOUT_scalar01 "../tv/cdatafile/c.w4a8_gemm.autotvout_scalar01.dat"
#define AUTOTB_TVIN_scalar02 "../tv/cdatafile/c.w4a8_gemm.autotvin_scalar02.dat"
#define AUTOTB_TVOUT_scalar02 "../tv/cdatafile/c.w4a8_gemm.autotvout_scalar02.dat"
#define AUTOTB_TVIN_scalar03 "../tv/cdatafile/c.w4a8_gemm.autotvin_scalar03.dat"
#define AUTOTB_TVOUT_scalar03 "../tv/cdatafile/c.w4a8_gemm.autotvout_scalar03.dat"
#define AUTOTB_TVIN_axi00_ptr0 "../tv/cdatafile/c.w4a8_gemm.autotvin_axi00_ptr0.dat"
#define AUTOTB_TVOUT_axi00_ptr0 "../tv/cdatafile/c.w4a8_gemm.autotvout_axi00_ptr0.dat"
#define AUTOTB_TVIN_axi01_ptr0 "../tv/cdatafile/c.w4a8_gemm.autotvin_axi01_ptr0.dat"
#define AUTOTB_TVOUT_axi01_ptr0 "../tv/cdatafile/c.w4a8_gemm.autotvout_axi01_ptr0.dat"
#define AUTOTB_TVIN_axi02_ptr0 "../tv/cdatafile/c.w4a8_gemm.autotvin_axi02_ptr0.dat"
#define AUTOTB_TVOUT_axi02_ptr0 "../tv/cdatafile/c.w4a8_gemm.autotvout_axi02_ptr0.dat"
#define AUTOTB_TVIN_m00_axi "../tv/cdatafile/c.w4a8_gemm.autotvin_m00_axi.dat"
#define AUTOTB_TVOUT_m00_axi "../tv/cdatafile/c.w4a8_gemm.autotvout_m00_axi.dat"
#define AUTOTB_TVIN_m01_axi "../tv/cdatafile/c.w4a8_gemm.autotvin_m01_axi.dat"
#define AUTOTB_TVOUT_m01_axi "../tv/cdatafile/c.w4a8_gemm.autotvout_m01_axi.dat"
#define AUTOTB_TVIN_m02_axi "../tv/cdatafile/c.w4a8_gemm.autotvin_m02_axi.dat"
#define AUTOTB_TVOUT_m02_axi "../tv/cdatafile/c.w4a8_gemm.autotvout_m02_axi.dat"

#define INTER_TCL "../tv/cdatafile/ref.tcl"

// tvout file define:
#define AUTOTB_TVOUT_PC_scalar00 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_scalar00.dat"
#define AUTOTB_TVOUT_PC_scalar01 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_scalar01.dat"
#define AUTOTB_TVOUT_PC_scalar02 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_scalar02.dat"
#define AUTOTB_TVOUT_PC_scalar03 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_scalar03.dat"
#define AUTOTB_TVOUT_PC_axi00_ptr0 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_axi00_ptr0.dat"
#define AUTOTB_TVOUT_PC_axi01_ptr0 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_axi01_ptr0.dat"
#define AUTOTB_TVOUT_PC_axi02_ptr0 "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_axi02_ptr0.dat"
#define AUTOTB_TVOUT_PC_m00_axi "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_m00_axi.dat"
#define AUTOTB_TVOUT_PC_m01_axi "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_m01_axi.dat"
#define AUTOTB_TVOUT_PC_m02_axi "../tv/rtldatafile/rtl.w4a8_gemm.autotvout_m02_axi.dat"


static const bool little_endian()
{
  int a = 1;
  return *(char*)&a == 1;
}

inline static void rev_endian(char* p, size_t nbytes)
{
  std::reverse(p, p+nbytes);
}

template<size_t bit_width>
struct transaction {
  typedef uint64_t depth_t;
  static const size_t wbytes = (bit_width+7)>>3;
  static const size_t dbytes = sizeof(depth_t);
  const depth_t depth;
  const size_t vbytes;
  const size_t tbytes;
  char * const p;
  typedef char (*p_dat)[wbytes];
  p_dat vp;

  transaction(depth_t depth)
    : depth(depth), vbytes(wbytes*depth), tbytes(dbytes+vbytes),
      p(new char[tbytes]) {
    *(depth_t*)p = depth;
    rev_endian(p, dbytes);
    vp = (p_dat) (p+dbytes);
  }

  void reorder() {
    rev_endian(p, dbytes);
    p_dat vp = (p_dat) (p+dbytes);
    for (depth_t i = 0; i < depth; ++i) {
      rev_endian(vp[i], wbytes);
    }
  }

  template<size_t psize>
  void import(char* param, depth_t num, int64_t offset) {
    param -= offset*psize;
    for (depth_t i = 0; i < num; ++i) {
      memcpy(vp[i], param, wbytes);
      param += psize;
      if (little_endian()) {
        rev_endian(vp[i], wbytes);
      }
    }
    vp += num;
  }

  template<size_t psize>
  void send(char* param, depth_t num) {
    for (depth_t i = 0; i < num; ++i) {
      memcpy(param, vp[i], wbytes);
      param += psize;
    }
    vp += num;
  }

  template<size_t psize>
  void send(char* param, depth_t num, int64_t skip) {
    for (depth_t i = 0; i < num; ++i) {
      memcpy(param, vp[skip+i], wbytes);
      param += psize;
    }
  }

  ~transaction() { if (p) { delete[] p; } }
};


inline static const std::string begin_str(int num)
{
  return std::string("[[transaction]]           ")
         .append(std::to_string(num))
         .append("\n");
}

inline static const std::string end_str()
{
  return std::string("[[/transaction]]\n");
}

const std::string formatData(unsigned char *pos, size_t wbits)
{
  bool LE = little_endian();
  size_t wbytes = (wbits+7)>>3;
  size_t i = LE ? wbytes-1 : 0;
  auto next = [&] () {
    auto c = pos[i];
    LE ? --i : ++i;
    return c;
  };
  std::ostringstream ss;
  ss << "0x";
  if (int t = (wbits & 0x7)) {
    if (t <= 4) {
      unsigned char mask = (1<<t)-1;
      ss << std::hex << std::setfill('0') << std::setw(1)
         << (int) (next() & mask);
      wbytes -= 1;
    }
  }
  for (size_t i = 0; i < wbytes; ++i) {
    ss << std::hex << std::setfill('0') << std::setw(2) << (int)next();
  }
  ss.put('\n');
  return ss.str();
}

static bool RTLOutputCheckAndReplacement(std::string &data)
{
  bool changed = false;
  for (size_t i = 2; i < data.size(); ++i) {
    if (data[i] == 'X' || data[i] == 'x') {
      data[i] = '0';
      changed = true;
    }
  }
  return changed;
}

struct SimException : public std::exception {
  const char *msg;
  const size_t line;
  SimException(const char *msg, const size_t line)
    : msg(msg), line(line)
  {
  }
};

template<size_t bit_width>
class PostCheck
{
  static const char *bad;
  static const char *err;
  std::fstream stream;
  std::string s;

  void send(char *p, ap_uint<bit_width> &data, size_t l, size_t rest)
  {
    if (rest == 0) {
      if (!little_endian()) {
        const size_t wbytes = (bit_width+7)>>3;
        rev_endian(p-wbytes, wbytes);
      }
    } else if (rest < 8) {
      *p = data.range(l+rest-1, l).to_uint();
      send(p+1, data, l+rest, 0);
    } else {
      *p = data.range(l+8-1, l).to_uint();
      send(p+1, data, l+8, rest-8);
    }
  }

  void readline()
  {
    std::getline(stream, s);
    if (stream.eof()) {
      throw SimException(bad, __LINE__);
    }
  }

public:
  char *param;
  size_t psize;
  size_t depth;

  PostCheck(const char *file)
  {
    stream.open(file);
    if (stream.fail()) {
      throw SimException(err, __LINE__);
    } else {
      readline();
      if (s != "[[[runtime]]]") {
        throw SimException(bad, __LINE__);
      }
    }
  }

  ~PostCheck() noexcept(false)
  {
    stream.close();
  }

  void run(size_t AESL_transaction_pc, size_t skip)
  {
    if (stream.peek() == '[') {
      readline();
    }

    for (size_t i = 0; i < skip; ++i) {
      readline();
    }

    bool foundX = false;
    for (size_t i = 0; i < depth; ++i) {
      readline();
      foundX |= RTLOutputCheckAndReplacement(s);
      ap_uint<bit_width> data(s.c_str(), 16);
      send(param+i*psize, data, 0, bit_width);
    }
    if (foundX) {
      std::cerr << "WARNING: [SIM 212-201] RTL produces unknown value "
                << "'x' or 'X' on some port, possible cause: "
                << "There are uninitialized variables in the design.\n";
    }

    if (stream.peek() == '[') {
      readline();
    }
  }
};

template<size_t bit_width>
const char* PostCheck<bit_width>::bad = "Bad TV file";

template<size_t bit_width>
const char* PostCheck<bit_width>::err = "Error on TV file";
      
class INTER_TCL_FILE {
  public:
INTER_TCL_FILE(const char* name) {
  mName = name; 
  scalar00_depth = 0;
  scalar01_depth = 0;
  scalar02_depth = 0;
  scalar03_depth = 0;
  axi00_ptr0_depth = 0;
  axi01_ptr0_depth = 0;
  axi02_ptr0_depth = 0;
  m00_axi_depth = 0;
  m01_axi_depth = 0;
  m02_axi_depth = 0;
  trans_num =0;
}
~INTER_TCL_FILE() {
  mFile.open(mName);
  if (!mFile.good()) {
    cout << "Failed to open file ref.tcl" << endl;
    exit (1); 
  }
  string total_list = get_depth_list();
  mFile << "set depth_list {\n";
  mFile << total_list;
  mFile << "}\n";
  mFile << "set trans_num "<<trans_num<<endl;
  mFile.close();
}
string get_depth_list () {
  stringstream total_list;
  total_list << "{scalar00 " << scalar00_depth << "}\n";
  total_list << "{scalar01 " << scalar01_depth << "}\n";
  total_list << "{scalar02 " << scalar02_depth << "}\n";
  total_list << "{scalar03 " << scalar03_depth << "}\n";
  total_list << "{axi00_ptr0 " << axi00_ptr0_depth << "}\n";
  total_list << "{axi01_ptr0 " << axi01_ptr0_depth << "}\n";
  total_list << "{axi02_ptr0 " << axi02_ptr0_depth << "}\n";
  total_list << "{m00_axi " << m00_axi_depth << "}\n";
  total_list << "{m01_axi " << m01_axi_depth << "}\n";
  total_list << "{m02_axi " << m02_axi_depth << "}\n";
  return total_list.str();
}
void set_num (int num , int* class_num) {
  (*class_num) = (*class_num) > num ? (*class_num) : num;
}
void set_string(std::string list, std::string* class_list) {
  (*class_list) = list;
}
  public:
    int scalar00_depth;
    int scalar01_depth;
    int scalar02_depth;
    int scalar03_depth;
    int axi00_ptr0_depth;
    int axi01_ptr0_depth;
    int axi02_ptr0_depth;
    int m00_axi_depth;
    int m01_axi_depth;
    int m02_axi_depth;
    int trans_num;
  private:
    ofstream mFile;
    const char* mName;
};


struct __cosim_s64__ { char data[64]; };
extern "C" void w4a8_gemm_hw_stub_wrapper(int, int, int, int, volatile void *, volatile void *, volatile void *);

extern "C" void apatb_w4a8_gemm_hw(int __xlx_apatb_param_scalar00, int __xlx_apatb_param_scalar01, int __xlx_apatb_param_scalar02, int __xlx_apatb_param_scalar03, volatile void * __xlx_apatb_param_axi00_ptr0, volatile void * __xlx_apatb_param_axi01_ptr0, volatile void * __xlx_apatb_param_axi02_ptr0) {
  refine_signal_handler();
  fstream wrapc_switch_file_token;
  wrapc_switch_file_token.open(".hls_cosim_wrapc_switch.log");
static AESL_FILE_HANDLER aesl_fh;
  int AESL_i;
  if (wrapc_switch_file_token.good())
  {

    CodeState = ENTER_WRAPC_PC;
    static unsigned AESL_transaction_pc = 0;
    string AESL_token;
    string AESL_num;
try {
static PostCheck<512> pc(AUTOTB_TVOUT_PC_m00_axi);
pc.psize = 64;
pc.param = (char*)__xlx_apatb_param_axi00_ptr0;
pc.depth = 1;
pc.run(AESL_transaction_pc, 0);
} catch (SimException &e) {
  std::cout << "at line " << e.line << " occurred exception, " << e.msg << "\n";
}
try {
static PostCheck<512> pc(AUTOTB_TVOUT_PC_m01_axi);
pc.psize = 64;
pc.param = (char*)__xlx_apatb_param_axi01_ptr0;
pc.depth = 1;
pc.run(AESL_transaction_pc, 0);
} catch (SimException &e) {
  std::cout << "at line " << e.line << " occurred exception, " << e.msg << "\n";
}
try {
static PostCheck<512> pc(AUTOTB_TVOUT_PC_m02_axi);
pc.psize = 64;
pc.param = (char*)__xlx_apatb_param_axi02_ptr0;
pc.depth = 1;
pc.run(AESL_transaction_pc, 0);
} catch (SimException &e) {
  std::cout << "at line " << e.line << " occurred exception, " << e.msg << "\n";
}

    AESL_transaction_pc++;
    return ;
  }
static unsigned AESL_transaction;
static INTER_TCL_FILE tcl_file(INTER_TCL);
std::vector<char> __xlx_sprintf_buffer(1024);
CodeState = ENTER_WRAPC;
CodeState = DUMP_INPUTS;
unsigned __xlx_offset_byte_param_axi00_ptr0 = 0;
unsigned __xlx_offset_byte_param_axi01_ptr0 = 0;
unsigned __xlx_offset_byte_param_axi02_ptr0 = 0;
aesl_fh.touch(AUTOTB_TVIN_m00_axi);
{
aesl_fh.write(AUTOTB_TVIN_m00_axi, begin_str(AESL_transaction));
__xlx_offset_byte_param_axi00_ptr0 = 0*64;
if (__xlx_apatb_param_axi00_ptr0) {
for (size_t i = 0; i < 1; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_axi00_ptr0 + i * 64;
std::string s = formatData(pos, 512);
aesl_fh.write(AUTOTB_TVIN_m00_axi, s);
}
}
tcl_file.set_num(1, &tcl_file.m00_axi_depth);
aesl_fh.write(AUTOTB_TVIN_m00_axi, end_str());
}
aesl_fh.touch(AUTOTB_TVIN_m01_axi);
{
aesl_fh.write(AUTOTB_TVIN_m01_axi, begin_str(AESL_transaction));
__xlx_offset_byte_param_axi01_ptr0 = 0*64;
if (__xlx_apatb_param_axi01_ptr0) {
for (size_t i = 0; i < 1; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_axi01_ptr0 + i * 64;
std::string s = formatData(pos, 512);
aesl_fh.write(AUTOTB_TVIN_m01_axi, s);
}
}
tcl_file.set_num(1, &tcl_file.m01_axi_depth);
aesl_fh.write(AUTOTB_TVIN_m01_axi, end_str());
}
aesl_fh.touch(AUTOTB_TVIN_m02_axi);
{
aesl_fh.write(AUTOTB_TVIN_m02_axi, begin_str(AESL_transaction));
__xlx_offset_byte_param_axi02_ptr0 = 0*64;
if (__xlx_apatb_param_axi02_ptr0) {
for (size_t i = 0; i < 1; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_axi02_ptr0 + i * 64;
std::string s = formatData(pos, 512);
aesl_fh.write(AUTOTB_TVIN_m02_axi, s);
}
}
tcl_file.set_num(1, &tcl_file.m02_axi_depth);
aesl_fh.write(AUTOTB_TVIN_m02_axi, end_str());
}
// print scalar00 Transactions
{
aesl_fh.write(AUTOTB_TVIN_scalar00, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_scalar00;
aesl_fh.write(AUTOTB_TVIN_scalar00, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.scalar00_depth);
aesl_fh.write(AUTOTB_TVIN_scalar00, end_str());
}

// print scalar01 Transactions
{
aesl_fh.write(AUTOTB_TVIN_scalar01, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_scalar01;
aesl_fh.write(AUTOTB_TVIN_scalar01, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.scalar01_depth);
aesl_fh.write(AUTOTB_TVIN_scalar01, end_str());
}

// print scalar02 Transactions
{
aesl_fh.write(AUTOTB_TVIN_scalar02, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_scalar02;
aesl_fh.write(AUTOTB_TVIN_scalar02, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.scalar02_depth);
aesl_fh.write(AUTOTB_TVIN_scalar02, end_str());
}

// print scalar03 Transactions
{
aesl_fh.write(AUTOTB_TVIN_scalar03, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_scalar03;
aesl_fh.write(AUTOTB_TVIN_scalar03, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.scalar03_depth);
aesl_fh.write(AUTOTB_TVIN_scalar03, end_str());
}

// print axi00_ptr0 Transactions
{
aesl_fh.write(AUTOTB_TVIN_axi00_ptr0, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_axi00_ptr0;
aesl_fh.write(AUTOTB_TVIN_axi00_ptr0, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.axi00_ptr0_depth);
aesl_fh.write(AUTOTB_TVIN_axi00_ptr0, end_str());
}

// print axi01_ptr0 Transactions
{
aesl_fh.write(AUTOTB_TVIN_axi01_ptr0, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_axi01_ptr0;
aesl_fh.write(AUTOTB_TVIN_axi01_ptr0, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.axi01_ptr0_depth);
aesl_fh.write(AUTOTB_TVIN_axi01_ptr0, end_str());
}

// print axi02_ptr0 Transactions
{
aesl_fh.write(AUTOTB_TVIN_axi02_ptr0, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_axi02_ptr0;
aesl_fh.write(AUTOTB_TVIN_axi02_ptr0, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.axi02_ptr0_depth);
aesl_fh.write(AUTOTB_TVIN_axi02_ptr0, end_str());
}

CodeState = CALL_C_DUT;
w4a8_gemm_hw_stub_wrapper(__xlx_apatb_param_scalar00, __xlx_apatb_param_scalar01, __xlx_apatb_param_scalar02, __xlx_apatb_param_scalar03, __xlx_apatb_param_axi00_ptr0, __xlx_apatb_param_axi01_ptr0, __xlx_apatb_param_axi02_ptr0);
CodeState = DUMP_OUTPUTS;
aesl_fh.touch(AUTOTB_TVOUT_m00_axi);
{
aesl_fh.write(AUTOTB_TVOUT_m00_axi, begin_str(AESL_transaction));
__xlx_offset_byte_param_axi00_ptr0 = 0*64;
if (__xlx_apatb_param_axi00_ptr0) {
for (size_t i = 0; i < 1; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_axi00_ptr0 + i * 64;
std::string s = formatData(pos, 512);
aesl_fh.write(AUTOTB_TVOUT_m00_axi, s);
}
}
tcl_file.set_num(1, &tcl_file.m00_axi_depth);
aesl_fh.write(AUTOTB_TVOUT_m00_axi, end_str());
}
aesl_fh.touch(AUTOTB_TVOUT_m01_axi);
{
aesl_fh.write(AUTOTB_TVOUT_m01_axi, begin_str(AESL_transaction));
__xlx_offset_byte_param_axi01_ptr0 = 0*64;
if (__xlx_apatb_param_axi01_ptr0) {
for (size_t i = 0; i < 1; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_axi01_ptr0 + i * 64;
std::string s = formatData(pos, 512);
aesl_fh.write(AUTOTB_TVOUT_m01_axi, s);
}
}
tcl_file.set_num(1, &tcl_file.m01_axi_depth);
aesl_fh.write(AUTOTB_TVOUT_m01_axi, end_str());
}
aesl_fh.touch(AUTOTB_TVOUT_m02_axi);
{
aesl_fh.write(AUTOTB_TVOUT_m02_axi, begin_str(AESL_transaction));
__xlx_offset_byte_param_axi02_ptr0 = 0*64;
if (__xlx_apatb_param_axi02_ptr0) {
for (size_t i = 0; i < 1; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_axi02_ptr0 + i * 64;
std::string s = formatData(pos, 512);
aesl_fh.write(AUTOTB_TVOUT_m02_axi, s);
}
}
tcl_file.set_num(1, &tcl_file.m02_axi_depth);
aesl_fh.write(AUTOTB_TVOUT_m02_axi, end_str());
}
CodeState = DELETE_CHAR_BUFFERS;
AESL_transaction++;
tcl_file.set_num(AESL_transaction , &tcl_file.trans_num);
}
