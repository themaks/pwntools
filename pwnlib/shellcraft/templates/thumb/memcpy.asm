<% from pwnlib.shellcraft import thumb, pretty, common %>
<%docstring>Copies memory.

Args:
    dest: Destination address
    src: Source address
    n: Number of bytes

Example:
    >>> s = shellcraft.push(u32(b"AAAA"))
    >>> s += shellcraft.push(u32(b"AAAA"))
    >>> s += shellcraft.mov("r5", "sp")
    >>> s += shellcraft.push(u32(b"BBBB"))
    >>> s += shellcraft.push(u32(b"BBBB"))
    >>> s += shellcraft.memcpy("sp", "r5", 4)
    >>> s += shellcraft.write(1, "sp", 8)
    >>> s += shellcraft.exit(0)
    >>> run_assembly(s).recvall()
    b'AAAABBBB'

</%docstring>
<%page args="dest, src, n"/>
<%
memcpy_loop = common.label("memcpy_loop")
%>
    /* memcpy(${pretty(dest)}, ${pretty(src)}, ${pretty(n)}) */
    ${thumb.setregs({'r4': dest, 'r1': src, 'r2': n})}
${memcpy_loop}:
    ldrb r3, [r1], #1
    strb r3, [r4], #1
    subs r2, r2, #1
    bgt ${memcpy_loop}
