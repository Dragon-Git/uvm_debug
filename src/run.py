import svuvm

def main():
    data = 0xdeadbeef
    for i in range(10):
        svuvm.write_reg(i, i)
        svuvm.wait_unit(i)
        data = svuvm.read_reg(i)
        print(data)