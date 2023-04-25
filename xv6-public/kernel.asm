
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 2e 10 80       	mov    $0x80102e40,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 6c 10 	movl   $0x80106cc0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 c0 40 00 00       	call   80104120 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 6c 10 	movl   $0x80106cc7,0x4(%esp)
8010009b:	80 
8010009c:	e8 4f 3f 00 00       	call   80103ff0 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 a5 41 00 00       	call   80104290 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 9a 41 00 00       	call   80104300 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 bf 3e 00 00       	call   80104030 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 ce 6c 10 80 	movl   $0x80106cce,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 1b 3f 00 00       	call   801040d0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 df 6c 10 80 	movl   $0x80106cdf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 da 3e 00 00       	call   801040d0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 8e 3e 00 00       	call   80104090 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 82 40 00 00       	call   80104290 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 ab 40 00 00       	jmp    80104300 <release>
    panic("brelse");
80100255:	c7 04 24 e6 6c 10 80 	movl   $0x80106ce6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 fd 3f 00 00       	call   80104290 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 43 34 00 00       	call   801036f0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 88 39 00 00       	call   80103c50 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 ea 3f 00 00       	call   80104300 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 92 13 00 00       	call   801016b0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 cc 3f 00 00       	call   80104300 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 35 24 00 00       	call   801027b0 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ed 6c 10 80 	movl   $0x80106ced,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 3b 76 10 80 	movl   $0x8010763b,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 8c 3d 00 00       	call   80104140 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 01 6d 10 80 	movl   $0x80106d01,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 22 54 00 00       	call   80105830 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 72 53 00 00       	call   80105830 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 66 53 00 00       	call   80105830 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 5a 53 00 00       	call   80105830 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 ef 3e 00 00       	call   801043f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 32 3e 00 00       	call   80104350 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 05 6d 10 80 	movl   $0x80106d05,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 30 6d 10 80 	movzbl -0x7fef92d0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 7d 3c 00 00       	call   80104290 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 c5 3c 00 00       	call   80104300 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 08 3c 00 00       	call   80104300 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 18 6d 10 80       	mov    $0x80106d18,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 f4 3a 00 00       	call   80104290 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 1f 6d 10 80 	movl   $0x80106d1f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 c6 3a 00 00       	call   80104290 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 d4 3a 00 00       	call   80104300 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 29 35 00 00       	call   80103de0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 94 35 00 00       	jmp    80103ec0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 28 6d 10 	movl   $0x80106d28,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 b6 37 00 00       	call   80104120 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 14 19 00 00       	call   801022b0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 3f 2d 00 00       	call   801036f0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 a4 21 00 00       	call   80102b60 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 39 15 00 00       	call   80101f00 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 d7 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 65 0f 00 00       	call   80101960 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 08 0f 00 00       	call   80101910 <iunlockput>
    end_op();
80100a08:	e8 c3 21 00 00       	call   80102bd0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 ef 5f 00 00       	call   80106a20 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 cd 0e 00 00       	call   80101960 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 b9 5d 00 00       	call   80106890 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 b8 5c 00 00       	call   801067d0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 72 5e 00 00       	call   801069a0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 d5 0d 00 00       	call   80101910 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 8b 20 00 00       	call   80102bd0 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 1f 5d 00 00       	call   80106890 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 17 5e 00 00       	call   801069a0 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 38 20 00 00       	call   80102bd0 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 41 6d 10 80 	movl   $0x80106d41,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 03 5f 00 00       	call   80106ad0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 6a 39 00 00       	call   80104570 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 59 39 00 00       	call   80104570 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 fa 5f 00 00       	call   80106c30 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 87 5f 00 00       	call   80106c30 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 3a 38 00 00       	call   80104530 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 1c 59 00 00       	call   80106640 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 74 5c 00 00       	call   801069a0 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 4d 6d 10 	movl   $0x80106d4d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 b6 33 00 00       	call   80104120 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 08 35 00 00       	call   80104290 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 4b 35 00 00       	call   80104300 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 34 35 00 00       	call   80104300 <release>
}
80100dcc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 9a 34 00 00       	call   80104290 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 f1 34 00 00       	call   80104300 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
    panic("filedup");
80100e17:	c7 04 24 54 6d 10 80 	movl   $0x80106d54,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 48 34 00 00       	call   80104290 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e6b:	e9 90 34 00 00       	jmp    80104300 <release>
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e8f:	e8 6c 34 00 00       	call   80104300 <release>
  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 f8 23 00 00       	call   801032b0 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ec0:	e8 9b 1c 00 00       	call   80102b60 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 00 09 00 00       	call   801017d0 <iput>
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
    end_op();
80100ed7:	e9 f4 1c 00 00       	jmp    80102bd0 <end_op>
    panic("fileclose");
80100edc:	c7 04 24 5c 6d 10 80 	movl   $0x80106d5c,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 a6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 14 0a 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 69 08 00 00       	call   80101790 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 41 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 d7 09 00 00       	call   80101960 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 f3 07 00 00       	call   80101790 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fb5:	e9 76 24 00 00       	jmp    80103430 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
  panic("fileread");
80100fc7:	c7 04 24 66 6d 10 80 	movl   $0x80106d66,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 57 07 00 00       	call   80101790 <iunlock>
      end_op();
80101039:	e8 92 1b 00 00       	call   80102bd0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101063:	e8 f8 1a 00 00       	call   80102b60 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 3d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 ce 09 00 00       	call   80101a60 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ec 06 00 00       	call   80101790 <iunlock>
      end_op();
801010a4:	e8 27 1b 00 00       	call   80102bd0 <end_op>
      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 5f 22 00 00       	jmp    80103340 <pipewrite>
        panic("short filewrite");
801010e1:	c7 04 24 6f 6d 10 80 	movl   $0x80106d6f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010ed:	c7 04 24 75 6d 10 80 	movl   $0x80106d75,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	89 d7                	mov    %edx,%edi
80101106:	56                   	push   %esi
80101107:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101108:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010110d:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101110:	c1 ea 0c             	shr    $0xc,%edx
80101113:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101120:	e8 ab ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101125:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
80101127:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010112d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010112f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101132:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101135:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101137:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101139:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010113e:	0f b6 c8             	movzbl %al,%ecx
80101141:	85 d9                	test   %ebx,%ecx
80101143:	74 20                	je     80101165 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101145:	f7 d3                	not    %ebx
80101147:	21 c3                	and    %eax,%ebx
80101149:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010114d:	89 34 24             	mov    %esi,(%esp)
80101150:	e8 ab 1b 00 00       	call   80102d00 <log_write>
  brelse(bp);
80101155:	89 34 24             	mov    %esi,(%esp)
80101158:	e8 83 f0 ff ff       	call   801001e0 <brelse>
}
8010115d:	83 c4 1c             	add    $0x1c,%esp
80101160:	5b                   	pop    %ebx
80101161:	5e                   	pop    %esi
80101162:	5f                   	pop    %edi
80101163:	5d                   	pop    %ebp
80101164:	c3                   	ret    
    panic("freeing free block");
80101165:	c7 04 24 7f 6d 10 80 	movl   $0x80106d7f,(%esp)
8010116c:	e8 ef f1 ff ff       	call   80100360 <panic>
80101171:	eb 0d                	jmp    80101180 <balloc>
80101173:	90                   	nop
80101174:	90                   	nop
80101175:	90                   	nop
80101176:	90                   	nop
80101177:	90                   	nop
80101178:	90                   	nop
80101179:	90                   	nop
8010117a:	90                   	nop
8010117b:	90                   	nop
8010117c:	90                   	nop
8010117d:	90                   	nop
8010117e:	90                   	nop
8010117f:	90                   	nop

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 2c             	sub    $0x2c,%esp
80101189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010118c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101191:	85 c0                	test   %eax,%eax
80101193:	0f 84 8c 00 00 00    	je     80101225 <balloc+0xa5>
80101199:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a3:	89 f0                	mov    %esi,%eax
801011a5:	c1 f8 0c             	sar    $0xc,%eax
801011a8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801011b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 13 ef ff ff       	call   801000d0 <bread>
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c8:	31 c0                	xor    %eax,%eax
801011ca:	eb 33                	jmp    801011ff <balloc+0x7f>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011d3:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
801011d5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	bf 01 00 00 00       	mov    $0x1,%edi
801011e2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
801011e9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011eb:	0f b6 fb             	movzbl %bl,%edi
801011ee:	85 cf                	test   %ecx,%edi
801011f0:	74 46                	je     80101238 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f2:	83 c0 01             	add    $0x1,%eax
801011f5:	83 c6 01             	add    $0x1,%esi
801011f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fd:	74 05                	je     80101204 <balloc+0x84>
801011ff:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101202:	72 cc                	jb     801011d0 <balloc+0x50>
    brelse(bp);
80101204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101207:	89 04 24             	mov    %eax,(%esp)
8010120a:	e8 d1 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010121f:	0f 82 7b ff ff ff    	jb     801011a0 <balloc+0x20>
  panic("balloc: out of blocks");
80101225:	c7 04 24 92 6d 10 80 	movl   $0x80106d92,(%esp)
8010122c:	e8 2f f1 ff ff       	call   80100360 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101238:	09 d9                	or     %ebx,%ecx
8010123a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010123d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101241:	89 1c 24             	mov    %ebx,(%esp)
80101244:	e8 b7 1a 00 00       	call   80102d00 <log_write>
        brelse(bp);
80101249:	89 1c 24             	mov    %ebx,(%esp)
8010124c:	e8 8f ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101251:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101254:	89 74 24 04          	mov    %esi,0x4(%esp)
80101258:	89 04 24             	mov    %eax,(%esp)
8010125b:	e8 70 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101260:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101267:	00 
80101268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010126f:	00 
  bp = bread(dev, bno);
80101270:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101272:	8d 40 5c             	lea    0x5c(%eax),%eax
80101275:	89 04 24             	mov    %eax,(%esp)
80101278:	e8 d3 30 00 00       	call   80104350 <memset>
  log_write(bp);
8010127d:	89 1c 24             	mov    %ebx,(%esp)
80101280:	e8 7b 1a 00 00       	call   80102d00 <log_write>
  brelse(bp);
80101285:	89 1c 24             	mov    %ebx,(%esp)
80101288:	e8 53 ef ff ff       	call   801001e0 <brelse>
}
8010128d:	83 c4 2c             	add    $0x2c,%esp
80101290:	89 f0                	mov    %esi,%eax
80101292:	5b                   	pop    %ebx
80101293:	5e                   	pop    %esi
80101294:	5f                   	pop    %edi
80101295:	5d                   	pop    %ebp
80101296:	c3                   	ret    
80101297:	89 f6                	mov    %esi,%esi
80101299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
{
801012a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012af:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
801012b2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801012b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012bc:	e8 cf 2f 00 00       	call   80104290 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c4:	eb 14                	jmp    801012da <iget+0x3a>
801012c6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c8:	85 f6                	test   %esi,%esi
801012ca:	74 3c                	je     80101308 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012cc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012d8:	74 46                	je     80101320 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012da:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	7e e7                	jle    801012c8 <iget+0x28>
801012e1:	39 3b                	cmp    %edi,(%ebx)
801012e3:	75 e3                	jne    801012c8 <iget+0x28>
801012e5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012e8:	75 de                	jne    801012c8 <iget+0x28>
      ip->ref++;
801012ea:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012ed:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
801012f6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012f9:	e8 02 30 00 00       	call   80104300 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	89 f0                	mov    %esi,%eax
80101303:	5b                   	pop    %ebx
80101304:	5e                   	pop    %esi
80101305:	5f                   	pop    %edi
80101306:	5d                   	pop    %ebp
80101307:	c3                   	ret    
80101308:	85 c9                	test   %ecx,%ecx
8010130a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101313:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101319:	75 bf                	jne    801012da <iget+0x3a>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 29                	je     8010134d <iget+0xad>
  ip->dev = dev;
80101324:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101326:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101329:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101330:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101337:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010133e:	e8 bd 2f 00 00       	call   80104300 <release>
}
80101343:	83 c4 1c             	add    $0x1c,%esp
80101346:	89 f0                	mov    %esi,%eax
80101348:	5b                   	pop    %ebx
80101349:	5e                   	pop    %esi
8010134a:	5f                   	pop    %edi
8010134b:	5d                   	pop    %ebp
8010134c:	c3                   	ret    
    panic("iget: no inodes");
8010134d:	c7 04 24 a8 6d 10 80 	movl   $0x80106da8,(%esp)
80101354:	e8 07 f0 ff ff       	call   80100360 <panic>
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c3                	mov    %eax,%ebx
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 46 5c             	mov    0x5c(%esi),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 66                	je     801013e0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	83 c4 1c             	add    $0x1c,%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101388:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010138b:	83 fe 7f             	cmp    $0x7f,%esi
8010138e:	77 77                	ja     80101407 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101390:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 5e                	je     801013f8 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010139a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139e:	8b 03                	mov    (%ebx),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 28 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013a8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013ac:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ae:	8b 32                	mov    (%edx),%esi
801013b0:	85 f6                	test   %esi,%esi
801013b2:	75 19                	jne    801013cd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013b4:	8b 03                	mov    (%ebx),%eax
801013b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013b9:	e8 c2 fd ff ff       	call   80101180 <balloc>
801013be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c1:	89 02                	mov    %eax,(%edx)
801013c3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013c5:	89 3c 24             	mov    %edi,(%esp)
801013c8:	e8 33 19 00 00       	call   80102d00 <log_write>
    brelse(bp);
801013cd:	89 3c 24             	mov    %edi,(%esp)
801013d0:	e8 0b ee ff ff       	call   801001e0 <brelse>
}
801013d5:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
801013d8:	89 f0                	mov    %esi,%eax
}
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
801013df:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 03                	mov    (%ebx),%eax
801013e2:	e8 99 fd ff ff       	call   80101180 <balloc>
801013e7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013ea:	83 c4 1c             	add    $0x1c,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 03                	mov    (%ebx),%eax
801013fa:	e8 81 fd ff ff       	call   80101180 <balloc>
801013ff:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101405:	eb 93                	jmp    8010139a <bmap+0x3a>
  panic("bmap: out of range");
80101407:	c7 04 24 b8 6d 10 80 	movl   $0x80106db8,(%esp)
8010140e:	e8 4d ef ff ff       	call   80100360 <panic>
80101413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <readsb>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101432:	00 
{
80101433:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101448:	00 
  bp = bread(dev, 1);
80101449:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010144b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101452:	e8 99 2f 00 00       	call   801043f0 <memmove>
  brelse(bp);
80101457:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010145a:	83 c4 10             	add    $0x10,%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
  brelse(bp);
80101460:	e9 7b ed ff ff       	jmp    801001e0 <brelse>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 cb 6d 10 	movl   $0x80106dcb,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010148b:	e8 90 2c 00 00       	call   80104120 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 d2 6d 10 	movl   $0x80106dd2,0x4(%esp)
801014a0:	80 
801014a1:	e8 4a 2b 00 00       	call   80103ff0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 5f ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014c6:	c7 04 24 38 6e 10 80 	movl   $0x80106e38,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 a2 2d 00 00       	call   80104350 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 3a 17 00 00       	call   80102d00 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
}
801015d6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
      return iget(dev, inum);
801015dc:	e9 bf fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
801015e1:	c7 04 24 d8 6d 10 80 	movl   $0x80106dd8,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 8b 2d 00 00       	call   801043f0 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 93 16 00 00       	call   80102d00 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 fa 2b 00 00       	call   80104290 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 5a 2c 00 00       	call   80104300 <release>
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b3 00 00 00    	je     80101776 <ilock+0xc6>
801016c3:	8b 53 08             	mov    0x8(%ebx),%edx
801016c6:	85 d2                	test   %edx,%edx
801016c8:	0f 8e a8 00 00 00    	jle    80101776 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 57 29 00 00       	call   80104030 <acquiresleep>
  if(ip->valid == 0){
801016d9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016dc:	85 c0                	test   %eax,%eax
801016de:	74 08                	je     801016e8 <ilock+0x38>
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
801016e6:	c3                   	ret    
801016e7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 a0 2c 00 00       	call   801043f0 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 76 ff ff ff    	jne    801016e0 <ilock+0x30>
      panic("ilock: no type");
8010176a:	c7 04 24 f0 6d 10 80 	movl   $0x80106df0,(%esp)
80101771:	e8 ea eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101776:	c7 04 24 ea 6d 10 80 	movl   $0x80106dea,(%esp)
8010177d:	e8 de eb ff ff       	call   80100360 <panic>
80101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 26 29 00 00       	call   801040d0 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017be:	e9 cd 28 00 00       	jmp    80104090 <releasesleep>
    panic("iunlock");
801017c3:	c7 04 24 ff 6d 10 80 	movl   $0x80106dff,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	89 3c 24             	mov    %edi,(%esp)
801017e2:	e8 49 28 00 00       	call   80104030 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ea:	85 d2                	test   %edx,%edx
801017ec:	74 07                	je     801017f5 <iput+0x25>
801017ee:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f3:	74 2b                	je     80101820 <iput+0x50>
  releasesleep(&ip->lock);
801017f5:	89 3c 24             	mov    %edi,(%esp)
801017f8:	e8 93 28 00 00       	call   80104090 <releasesleep>
  acquire(&icache.lock);
801017fd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101804:	e8 87 2a 00 00       	call   80104290 <acquire>
  ip->ref--;
80101809:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101814:	83 c4 1c             	add    $0x1c,%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
  release(&icache.lock);
8010181b:	e9 e0 2a 00 00       	jmp    80104300 <release>
    acquire(&icache.lock);
80101820:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101827:	e8 64 2a 00 00       	call   80104290 <acquire>
    int r = ip->ref;
8010182c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010182f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101836:	e8 c5 2a 00 00       	call   80104300 <release>
    if(r == 1){
8010183b:	83 fb 01             	cmp    $0x1,%ebx
8010183e:	75 b5                	jne    801017f5 <iput+0x25>
80101840:	8d 4e 30             	lea    0x30(%esi),%ecx
80101843:	89 f3                	mov    %esi,%ebx
80101845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x87>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xa0>
    if(ip->addrs[i]){
80101857:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 f2                	je     80101850 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010185e:	8b 06                	mov    (%esi),%eax
80101860:	e8 9b f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101865:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010186c:	eb e2                	jmp    80101850 <iput+0x80>
8010186e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 2b                	jne    801018a8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010187d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101884:	89 34 24             	mov    %esi,(%esp)
80101887:	e8 64 fd ff ff       	call   801015f0 <iupdate>
      ip->type = 0;
8010188c:	31 c0                	xor    %eax,%eax
8010188e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
8010189a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a1:	e9 4f ff ff ff       	jmp    801017f5 <iput+0x25>
801018a6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ac:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018ae:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	89 04 24             	mov    %eax,(%esp)
801018b3:	e8 18 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018bb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018c1:	89 cf                	mov    %ecx,%edi
801018c3:	31 c0                	xor    %eax,%eax
801018c5:	eb 0e                	jmp    801018d5 <iput+0x105>
801018c7:	90                   	nop
801018c8:	83 c3 01             	add    $0x1,%ebx
801018cb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d1:	89 d8                	mov    %ebx,%eax
801018d3:	74 10                	je     801018e5 <iput+0x115>
      if(a[j])
801018d5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018d8:	85 d2                	test   %edx,%edx
801018da:	74 ec                	je     801018c8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018dc:	8b 06                	mov    (%esi),%eax
801018de:	e8 1d f8 ff ff       	call   80101100 <bfree>
801018e3:	eb e3                	jmp    801018c8 <iput+0xf8>
    brelse(bp);
801018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018eb:	89 04 24             	mov    %eax,(%esp)
801018ee:	e8 ed e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018f3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f9:	8b 06                	mov    (%esi),%eax
801018fb:	e8 00 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
80101900:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101907:	00 00 00 
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iput+0xad>
8010190f:	90                   	nop

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 14             	sub    $0x14,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	89 1c 24             	mov    %ebx,(%esp)
8010191d:	e8 6e fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101922:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101925:	83 c4 14             	add    $0x14,%esp
80101928:	5b                   	pop    %ebx
80101929:	5d                   	pop    %ebp
  iput(ip);
8010192a:	e9 a1 fe ff ff       	jmp    801017d0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 2c             	sub    $0x2c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010196c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
80101972:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101975:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101978:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010197d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101980:	0f 84 aa 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101986:	8b 47 58             	mov    0x58(%edi),%eax
80101989:	39 f0                	cmp    %esi,%eax
8010198b:	0f 82 c7 00 00 00    	jb     80101a58 <readi+0xf8>
80101991:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101994:	89 da                	mov    %ebx,%edx
80101996:	01 f2                	add    %esi,%edx
80101998:	0f 82 ba 00 00 00    	jb     80101a58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199e:	89 c1                	mov    %eax,%ecx
801019a0:	29 f1                	sub    %esi,%ecx
801019a2:	39 d0                	cmp    %edx,%eax
801019a4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a7:	31 c0                	xor    %eax,%eax
801019a9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ae:	74 70                	je     80101a20 <readi+0xc0>
801019b0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019b3:	89 c7                	mov    %eax,%edi
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019bb:	89 f2                	mov    %esi,%edx
801019bd:	c1 ea 09             	shr    $0x9,%edx
801019c0:	89 d8                	mov    %ebx,%eax
801019c2:	e8 99 f9 ff ff       	call   80101360 <bmap>
801019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019cb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019cd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d2:	89 04 24             	mov    %eax,(%esp)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019dd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019df:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019e1:	89 f0                	mov    %esi,%eax
801019e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ee:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	01 df                	add    %ebx,%edi
80101a00:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 e3 29 00 00       	call   801043f0 <memmove>
    brelse(bp);
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a1e:	77 98                	ja     801019b8 <readi+0x58>
  }
  return n;
80101a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a23:	83 c4 2c             	add    $0x2c,%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a4b:	83 c4 2c             	add    $0x2c,%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a52:	ff e0                	jmp    *%eax
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c4                	jmp    80101a23 <readi+0xc3>
80101a5f:	90                   	nop

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 2c             	sub    $0x2c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 e3 00 00 00    	jb     80101b78 <writei+0x118>
80101a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a98:	89 c8                	mov    %ecx,%eax
80101a9a:	01 f0                	add    %esi,%eax
80101a9c:	0f 82 d6 00 00 00    	jb     80101b78 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa7:	0f 87 cb 00 00 00    	ja     80101b78 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aad:	85 c9                	test   %ecx,%ecx
80101aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab6:	74 77                	je     80101b2f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101abb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac2:	c1 ea 09             	shr    $0x9,%edx
80101ac5:	89 f8                	mov    %edi,%eax
80101ac7:	e8 94 f8 ff ff       	call   80101360 <bmap>
80101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ad0:	8b 07                	mov    (%edi),%eax
80101ad2:	89 04 24             	mov    %eax,(%esp)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101add:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae5:	89 f0                	mov    %esi,%eax
80101ae7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aec:	29 c3                	sub    %eax,%ebx
80101aee:	39 cb                	cmp    %ecx,%ebx
80101af0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 e7 28 00 00       	call   801043f0 <memmove>
    log_write(bp);
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 ef 11 00 00       	call   80102d00 <log_write>
    brelse(bp);
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b1f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b22:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b25:	77 91                	ja     80101ab8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2d:	72 39                	jb     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b32:	83 c4 2c             	add    $0x2c,%esp
80101b35:	5b                   	pop    %ebx
80101b36:	5e                   	pop    %esi
80101b37:	5f                   	pop    %edi
80101b38:	5d                   	pop    %ebp
80101b39:	c3                   	ret    
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 2e                	ja     80101b78 <writei+0x118>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 23                	je     80101b78 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 7a fa ff ff       	call   801015f0 <iupdate>
80101b76:	eb b7                	jmp    80101b2f <writei+0xcf>
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ba0:	00 
80101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 04 24             	mov    %eax,(%esp)
80101bab:	e8 c0 28 00 00       	call   80104470 <strncmp>
}
80101bb0:	c9                   	leave  
80101bb1:	c3                   	ret    
80101bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 97 00 00 00    	jne    80101c6e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 73                	jmp    80101c58 <dirlookup+0x98>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 68                	jbe    80101c58 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bf7:	00 
80101bf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c00:	89 1c 24             	mov    %ebx,(%esp)
80101c03:	e8 58 fd ff ff       	call   80101960 <readi>
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 55                	jne    80101c62 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 d4                	je     80101be8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c25:	00 
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 42 28 00 00       	call   80104470 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 b6                	jne    80101be8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 05                	je     80101c3e <dirlookup+0x7e>
        *poff = off;
80101c39:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c42:	8b 03                	mov    (%ebx),%eax
80101c44:	e8 57 f6 ff ff       	call   801012a0 <iget>
    }
  }

  return 0;
}
80101c49:	83 c4 2c             	add    $0x2c,%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
80101c50:	c3                   	ret    
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c5b:	31 c0                	xor    %eax,%eax
}
80101c5d:	5b                   	pop    %ebx
80101c5e:	5e                   	pop    %esi
80101c5f:	5f                   	pop    %edi
80101c60:	5d                   	pop    %ebp
80101c61:	c3                   	ret    
      panic("dirlookup read");
80101c62:	c7 04 24 19 6e 10 80 	movl   $0x80106e19,(%esp)
80101c69:	e8 f2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c6e:	c7 04 24 07 6e 10 80 	movl   $0x80106e07,(%esp)
80101c75:	e8 e6 e6 ff ff       	call   80100360 <panic>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	89 cf                	mov    %ecx,%edi
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c93:	0f 84 51 01 00 00    	je     80101dea <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 52 1a 00 00       	call   801036f0 <myproc>
80101c9e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 e3 25 00 00       	call   80104290 <acquire>
  ip->ref++;
80101cad:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 43 26 00 00       	call   80104300 <release>
80101cbd:	eb 04                	jmp    80101cc3 <namex+0x43>
80101cbf:	90                   	nop
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x40>
  if(*path == 0)
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 ed 00 00 00    	je     80101dbf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	89 da                	mov    %ebx,%edx
80101cd7:	84 c0                	test   %al,%al
80101cd9:	0f 84 b1 00 00 00    	je     80101d90 <namex+0x110>
80101cdf:	3c 2f                	cmp    $0x2f,%al
80101ce1:	75 0f                	jne    80101cf2 <namex+0x72>
80101ce3:	e9 a8 00 00 00       	jmp    80101d90 <namex+0x110>
80101ce8:	3c 2f                	cmp    $0x2f,%al
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	74 0a                	je     80101cfc <namex+0x7c>
    path++;
80101cf2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cf5:	0f b6 02             	movzbl (%edx),%eax
80101cf8:	84 c0                	test   %al,%al
80101cfa:	75 ec                	jne    80101ce8 <namex+0x68>
80101cfc:	89 d1                	mov    %edx,%ecx
80101cfe:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d00:	83 f9 0d             	cmp    $0xd,%ecx
80101d03:	0f 8e 8f 00 00 00    	jle    80101d98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d14:	00 
80101d15:	89 3c 24             	mov    %edi,(%esp)
80101d18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d1b:	e8 d0 26 00 00       	call   801043f0 <memmove>
    path++;
80101d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d23:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d28:	75 0e                	jne    80101d38 <namex+0xb8>
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 70 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d45:	0f 85 85 00 00 00    	jne    80101dd0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d4e:	85 d2                	test   %edx,%edx
80101d50:	74 09                	je     80101d5b <namex+0xdb>
80101d52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d55:	0f 84 a5 00 00 00    	je     80101e00 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d62:	00 
80101d63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 51 fe ff ff       	call   80101bc0 <dirlookup>
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 5d                	je     80101dd0 <namex+0x150>
  iunlock(ip);
80101d73:	89 34 24             	mov    %esi,(%esp)
80101d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d79:	e8 12 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	89 c6                	mov    %eax,%esi
80101d8b:	e9 33 ff ff ff       	jmp    80101cc3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101d90:	31 c9                	xor    %ecx,%ecx
80101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da9:	e8 42 26 00 00       	call   801043f0 <memmove>
    name[len] = 0;
80101dae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db8:	89 d3                	mov    %edx,%ebx
80101dba:	e9 66 ff ff ff       	jmp    80101d25 <namex+0xa5>
  }
  if(nameiparent){
80101dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc2:	85 c0                	test   %eax,%eax
80101dc4:	75 4c                	jne    80101e12 <namex+0x192>
80101dc6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
80101dcf:	c3                   	ret    
  iunlock(ip);
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 b8 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101dd8:	89 34 24             	mov    %esi,(%esp)
80101ddb:	e8 f0 f9 ff ff       	call   801017d0 <iput>
}
80101de0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101de3:	31 c0                	xor    %eax,%eax
}
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dea:	ba 01 00 00 00       	mov    $0x1,%edx
80101def:	b8 01 00 00 00       	mov    $0x1,%eax
80101df4:	e8 a7 f4 ff ff       	call   801012a0 <iget>
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 c3 fe ff ff       	jmp    80101cc3 <namex+0x43>
      iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 88 f9 ff ff       	call   80101790 <iunlock>
}
80101e08:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e0b:	89 f0                	mov    %esi,%eax
}
80101e0d:	5b                   	pop    %ebx
80101e0e:	5e                   	pop    %esi
80101e0f:	5f                   	pop    %edi
80101e10:	5d                   	pop    %ebp
80101e11:	c3                   	ret    
    iput(ip);
80101e12:	89 34 24             	mov    %esi,(%esp)
80101e15:	e8 b6 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e1a:	31 c0                	xor    %eax,%eax
80101e1c:	eb aa                	jmp    80101dc8 <namex+0x148>
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 2c             	sub    $0x2c,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e36:	00 
80101e37:	89 1c 24             	mov    %ebx,(%esp)
80101e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3e:	e8 7d fd ff ff       	call   80101bc0 <dirlookup>
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 8b 00 00 00    	jne    80101ed6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4e:	31 ff                	xor    %edi,%edi
80101e50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e53:	85 c0                	test   %eax,%eax
80101e55:	75 13                	jne    80101e6a <dirlink+0x4a>
80101e57:	eb 35                	jmp    80101e8e <dirlink+0x6e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8d 57 10             	lea    0x10(%edi),%edx
80101e63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e66:	89 d7                	mov    %edx,%edi
80101e68:	76 24                	jbe    80101e8e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e71:	00 
80101e72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7a:	89 1c 24             	mov    %ebx,(%esp)
80101e7d:	e8 de fa ff ff       	call   80101960 <readi>
80101e82:	83 f8 10             	cmp    $0x10,%eax
80101e85:	75 5e                	jne    80101ee5 <dirlink+0xc5>
    if(de.inum == 0)
80101e87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8c:	75 d2                	jne    80101e60 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e98:	00 
80101e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea0:	89 04 24             	mov    %eax,(%esp)
80101ea3:	e8 38 26 00 00       	call   801044e0 <strncpy>
  de.inum = inum;
80101ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb2:	00 
80101eb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ebe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec2:	e8 99 fb ff ff       	call   80101a60 <writei>
80101ec7:	83 f8 10             	cmp    $0x10,%eax
80101eca:	75 25                	jne    80101ef1 <dirlink+0xd1>
  return 0;
80101ecc:	31 c0                	xor    %eax,%eax
}
80101ece:	83 c4 2c             	add    $0x2c,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
    iput(ip);
80101ed6:	89 04 24             	mov    %eax,(%esp)
80101ed9:	e8 f2 f8 ff ff       	call   801017d0 <iput>
    return -1;
80101ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee3:	eb e9                	jmp    80101ece <dirlink+0xae>
      panic("dirlink read");
80101ee5:	c7 04 24 28 6e 10 80 	movl   $0x80106e28,(%esp)
80101eec:	e8 6f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101ef1:	c7 04 24 22 74 10 80 	movl   $0x80107422,(%esp)
80101ef8:	e8 63 e4 ff ff       	call   80100360 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <namei>:

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	56                   	push   %esi
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	53                   	push   %ebx
80101f47:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	0f 84 99 00 00 00    	je     80101feb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f52:	8b 48 08             	mov    0x8(%eax),%ecx
80101f55:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f5b:	0f 87 7e 00 00 00    	ja     80101fdf <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f69:	83 e0 c0             	and    $0xffffffc0,%eax
80101f6c:	3c 40                	cmp    $0x40,%al
80101f6e:	75 f8                	jne    80101f68 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f70:	31 db                	xor    %ebx,%ebx
80101f72:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ee                   	out    %al,(%dx)
80101f7a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	ee                   	out    %al,(%dx)
80101f85:	0f b6 c1             	movzbl %cl,%eax
80101f88:	b2 f3                	mov    $0xf3,%dl
80101f8a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f8b:	89 c8                	mov    %ecx,%eax
80101f8d:	b2 f4                	mov    $0xf4,%dl
80101f8f:	c1 f8 08             	sar    $0x8,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	b2 f5                	mov    $0xf5,%dl
80101f95:	89 d8                	mov    %ebx,%eax
80101f97:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f98:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9c:	b2 f6                	mov    $0xf6,%dl
80101f9e:	83 e0 01             	and    $0x1,%eax
80101fa1:	c1 e0 04             	shl    $0x4,%eax
80101fa4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fa7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fa8:	f6 06 04             	testb  $0x4,(%esi)
80101fab:	75 13                	jne    80101fc0 <idestart+0x80>
80101fad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop
80101fc0:	b2 f7                	mov    $0xf7,%dl
80101fc2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fc7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fcd:	83 c6 5c             	add    $0x5c,%esi
80101fd0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd5:	fc                   	cld    
80101fd6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
    panic("incorrect blockno");
80101fdf:	c7 04 24 94 6e 10 80 	movl   $0x80106e94,(%esp)
80101fe6:	e8 75 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101feb:	c7 04 24 8b 6e 10 80 	movl   $0x80106e8b,(%esp)
80101ff2:	e8 69 e3 ff ff       	call   80100360 <panic>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102006:	c7 44 24 04 a6 6e 10 	movl   $0x80106ea6,0x4(%esp)
8010200d:	80 
8010200e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102015:	e8 06 21 00 00       	call   80104120 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010201a:	a1 20 2d 11 80       	mov    0x80112d20,%eax
8010201f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102026:	83 e8 01             	sub    $0x1,%eax
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	e8 7e 02 00 00       	call   801022b0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102032:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102037:	90                   	nop
80102038:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x5d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x6c>
8010205d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x58>
      havedisk1 = 1;
80102062:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102069:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102090:	e8 fb 21 00 00       	call   80104290 <acquire>

  if((b = idequeue) == 0){
80102095:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 1f 1d 00 00       	call   80103de0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020c1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
    idestart(idequeue);
801020ca:	e8 71 fe ff ff       	call   80101f40 <idestart>
    release(&idelock);
801020cf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d6:	e8 25 22 00 00       	call   80104300 <release>

  release(&idelock);
}
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 9b 1f 00 00       	call   801040d0 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010215f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102166:	e8 25 21 00 00       	call   80104290 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010218c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010218e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
    sleep(b, &idelock);
801021a0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 a0 1a 00 00       	call   80103c50 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
  }


  release(&idelock);
801021ba:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
  release(&idelock);
801021c6:	e9 35 21 00 00       	jmp    80104300 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
    idestart(b);
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 67 fd ff ff       	call   80101f40 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
    panic("iderw: buf not locked");
801021db:	c7 04 24 aa 6e 10 80 	movl   $0x80106eaa,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021e7:	c7 04 24 d5 6e 10 80 	movl   $0x80106ed5,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801021f3:	c7 04 24 c0 6e 10 80 	movl   $0x80106ec0,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102208:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010220f:	00 c0 fe 
  ioapic->reg = reg;
80102212:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102219:	00 00 00 
  return ioapic->data;
8010221c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102222:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102225:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010222b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102231:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102238:	c1 e8 10             	shr    $0x10,%eax
8010223b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010223e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102241:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102244:	39 c2                	cmp    %eax,%edx
80102246:	74 12                	je     8010225a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102248:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
8010224f:	e8 fc e3 ff ff       	call   80100650 <cprintf>
80102254:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010225a:	ba 10 00 00 00       	mov    $0x10,%edx
8010225f:	31 c0                	xor    %eax,%eax
80102261:	eb 07                	jmp    8010226a <ioapicinit+0x6a>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010226a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010226c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102272:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102275:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010227b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010227e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102281:	8d 4a 01             	lea    0x1(%edx),%ecx
80102284:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102287:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102289:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010228f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102291:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102298:	7d ce                	jge    80102268 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5d                   	pop    %ebp
801022a0:	c3                   	ret    
801022a1:	eb 0d                	jmp    801022b0 <ioapicenable>
801022a3:	90                   	nop
801022a4:	90                   	nop
801022a5:	90                   	nop
801022a6:	90                   	nop
801022a7:	90                   	nop
801022a8:	90                   	nop
801022a9:	90                   	nop
801022aa:	90                   	nop
801022ab:	90                   	nop
801022ac:	90                   	nop
801022ad:	90                   	nop
801022ae:	90                   	nop
801022af:	90                   	nop

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	8b 55 08             	mov    0x8(%ebp),%edx
801022b6:	53                   	push   %ebx
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ba:	8d 5a 20             	lea    0x20(%edx),%ebx
801022bd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022c1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022ca:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022cc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022d5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022d8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022da:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022e0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022e3:	5b                   	pop    %ebx
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb c8 54 11 80    	cmp    $0x801154c8,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 21 20 00 00       	call   80104350 <memset>

  if(kmem.use_lock)
8010232f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102339:	a1 78 26 11 80       	mov    0x80112678,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102340:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102345:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
    release(&kmem.lock);
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102358:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
    release(&kmem.lock);
80102364:	e9 97 1f 00 00       	jmp    80104300 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102370:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102377:	e8 14 1f 00 00       	call   80104290 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
    panic("kfree");
8010237e:	c7 04 24 26 6f 10 80 	movl   $0x80106f26,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
}
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023eb:	c7 44 24 04 2c 6f 10 	movl   $0x80106f2c,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023fa:	e8 21 1d 00 00       	call   80104120 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102402:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102409:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>
  kmem.use_lock = 1;
8010248e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102495:	00 00 00 
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
    release(&kmem.lock);
801024c6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024cd:	e8 2e 1e 00 00       	call   80104300 <release>
  return (char*)r;
}
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024e0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024e7:	e8 a4 1d 00 00       	call   80104290 <acquire>
801024ec:	a1 74 26 11 80       	mov    0x80112674,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kCountFreePages>:

uint numFreePages;

void kCountFreePages(void) {
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	83 ec 18             	sub    $0x18,%esp
      numFreePages = 0;
      acquire(&kmem.lock); // avoid counting the number of free pages when pages are being allocated by the function.
80102506:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
      numFreePages = 0;
8010250d:	c7 05 7c 26 11 80 00 	movl   $0x0,0x8011267c
80102514:	00 00 00 
      acquire(&kmem.lock); // avoid counting the number of free pages when pages are being allocated by the function.
80102517:	e8 74 1d 00 00       	call   80104290 <acquire>
      struct run* pageIter = kmem.freelist;
8010251c:	a1 78 26 11 80       	mov    0x80112678,%eax
80102521:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
      // kmem.freeList is a linked list storing the addresses of the free pages. So we can iterate and count the numFreePages.
      while(pageIter != 0) {
80102527:	85 c0                	test   %eax,%eax
80102529:	8d 51 01             	lea    0x1(%ecx),%edx
8010252c:	74 11                	je     8010253f <kCountFreePages+0x3f>
8010252e:	66 90                	xchg   %ax,%ax
        numFreePages += 1;
80102530:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
        pageIter = pageIter->next;
80102536:	8b 00                	mov    (%eax),%eax
80102538:	83 c2 01             	add    $0x1,%edx
      while(pageIter != 0) {
8010253b:	85 c0                	test   %eax,%eax
8010253d:	75 f1                	jne    80102530 <kCountFreePages+0x30>
      }
      release(&kmem.lock);
8010253f:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102546:	e8 b5 1d 00 00       	call   80104300 <release>
}
8010254b:	c9                   	leave  
8010254c:	c3                   	ret    
8010254d:	66 90                	xchg   %ax,%ax
8010254f:	90                   	nop

80102550 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102550:	ba 64 00 00 00       	mov    $0x64,%edx
80102555:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102556:	a8 01                	test   $0x1,%al
80102558:	0f 84 ba 00 00 00    	je     80102618 <kbdgetc+0xc8>
8010255e:	b2 60                	mov    $0x60,%dl
80102560:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102561:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102564:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010256a:	0f 84 88 00 00 00    	je     801025f8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102570:	84 c0                	test   %al,%al
80102572:	79 2c                	jns    801025a0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102574:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010257a:	f6 c2 40             	test   $0x40,%dl
8010257d:	75 05                	jne    80102584 <kbdgetc+0x34>
8010257f:	89 c1                	mov    %eax,%ecx
80102581:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102584:	0f b6 81 60 70 10 80 	movzbl -0x7fef8fa0(%ecx),%eax
8010258b:	83 c8 40             	or     $0x40,%eax
8010258e:	0f b6 c0             	movzbl %al,%eax
80102591:	f7 d0                	not    %eax
80102593:	21 d0                	and    %edx,%eax
80102595:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010259a:	31 c0                	xor    %eax,%eax
8010259c:	c3                   	ret    
8010259d:	8d 76 00             	lea    0x0(%esi),%esi
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
801025aa:	f6 c3 40             	test   $0x40,%bl
801025ad:	74 09                	je     801025b8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025af:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025b2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801025b5:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801025b8:	0f b6 91 60 70 10 80 	movzbl -0x7fef8fa0(%ecx),%edx
  shift ^= togglecode[data];
801025bf:	0f b6 81 60 6f 10 80 	movzbl -0x7fef90a0(%ecx),%eax
  shift |= shiftcode[data];
801025c6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025c8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025ca:	89 d0                	mov    %edx,%eax
801025cc:	83 e0 03             	and    $0x3,%eax
801025cf:	8b 04 85 40 6f 10 80 	mov    -0x7fef90c0(,%eax,4),%eax
  shift ^= togglecode[data];
801025d6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025dc:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025df:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025e3:	74 0b                	je     801025f0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025e5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e8:	83 fa 19             	cmp    $0x19,%edx
801025eb:	77 1b                	ja     80102608 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ed:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025f0:	5b                   	pop    %ebx
801025f1:	5d                   	pop    %ebp
801025f2:	c3                   	ret    
801025f3:	90                   	nop
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025f8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025ff:	31 c0                	xor    %eax,%eax
80102601:	c3                   	ret    
80102602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102608:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010260b:	8d 50 20             	lea    0x20(%eax),%edx
8010260e:	83 f9 19             	cmp    $0x19,%ecx
80102611:	0f 46 c2             	cmovbe %edx,%eax
  return c;
80102614:	eb da                	jmp    801025f0 <kbdgetc+0xa0>
80102616:	66 90                	xchg   %ax,%ax
    return -1;
80102618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010261d:	c3                   	ret    
8010261e:	66 90                	xchg   %ax,%ax

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102626:	c7 04 24 50 25 10 80 	movl   $0x80102550,(%esp)
8010262d:	e8 7e e1 ff ff       	call   801007b0 <consoleintr>
}
80102632:	c9                   	leave  
80102633:	c3                   	ret    
80102634:	66 90                	xchg   %ax,%ax
80102636:	66 90                	xchg   %ax,%ax
80102638:	66 90                	xchg   %ax,%ax
8010263a:	66 90                	xchg   %ax,%ax
8010263c:	66 90                	xchg   %ax,%ax
8010263e:	66 90                	xchg   %ax,%ax

80102640 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102640:	55                   	push   %ebp
80102641:	89 c1                	mov    %eax,%ecx
80102643:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102645:	ba 70 00 00 00       	mov    $0x70,%edx
8010264a:	53                   	push   %ebx
8010264b:	31 c0                	xor    %eax,%eax
8010264d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010264e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102653:	89 da                	mov    %ebx,%edx
80102655:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102656:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102659:	b2 70                	mov    $0x70,%dl
8010265b:	89 01                	mov    %eax,(%ecx)
8010265d:	b8 02 00 00 00       	mov    $0x2,%eax
80102662:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102663:	89 da                	mov    %ebx,%edx
80102665:	ec                   	in     (%dx),%al
80102666:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102669:	b2 70                	mov    $0x70,%dl
8010266b:	89 41 04             	mov    %eax,0x4(%ecx)
8010266e:	b8 04 00 00 00       	mov    $0x4,%eax
80102673:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102674:	89 da                	mov    %ebx,%edx
80102676:	ec                   	in     (%dx),%al
80102677:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267a:	b2 70                	mov    $0x70,%dl
8010267c:	89 41 08             	mov    %eax,0x8(%ecx)
8010267f:	b8 07 00 00 00       	mov    $0x7,%eax
80102684:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102685:	89 da                	mov    %ebx,%edx
80102687:	ec                   	in     (%dx),%al
80102688:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268b:	b2 70                	mov    $0x70,%dl
8010268d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102690:	b8 08 00 00 00       	mov    $0x8,%eax
80102695:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102696:	89 da                	mov    %ebx,%edx
80102698:	ec                   	in     (%dx),%al
80102699:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269c:	b2 70                	mov    $0x70,%dl
8010269e:	89 41 10             	mov    %eax,0x10(%ecx)
801026a1:	b8 09 00 00 00       	mov    $0x9,%eax
801026a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a7:	89 da                	mov    %ebx,%edx
801026a9:	ec                   	in     (%dx),%al
801026aa:	0f b6 d8             	movzbl %al,%ebx
801026ad:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026b0:	5b                   	pop    %ebx
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret    
801026b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <lapicinit>:
  if(!lapic)
801026c0:	a1 80 26 11 80       	mov    0x80112680,%eax
{
801026c5:	55                   	push   %ebp
801026c6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026c8:	85 c0                	test   %eax,%eax
801026ca:	0f 84 c0 00 00 00    	je     80102790 <lapicinit+0xd0>
  lapic[index] = value;
801026d0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026d7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026f1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026fe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102701:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102704:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010270b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102711:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102718:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271b:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010271e:	8b 50 30             	mov    0x30(%eax),%edx
80102721:	c1 ea 10             	shr    $0x10,%edx
80102724:	80 fa 03             	cmp    $0x3,%dl
80102727:	77 6f                	ja     80102798 <lapicinit+0xd8>
  lapic[index] = value;
80102729:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102730:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102733:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102736:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102740:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102743:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102750:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102757:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102764:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102767:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102771:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102774:	8b 50 20             	mov    0x20(%eax),%edx
80102777:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102778:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010277e:	80 e6 10             	and    $0x10,%dh
80102781:	75 f5                	jne    80102778 <lapicinit+0xb8>
  lapic[index] = value;
80102783:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010278a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010278d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102790:	5d                   	pop    %ebp
80102791:	c3                   	ret    
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102798:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010279f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027a2:	8b 50 20             	mov    0x20(%eax),%edx
801027a5:	eb 82                	jmp    80102729 <lapicinit+0x69>
801027a7:	89 f6                	mov    %esi,%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicid>:
  if (!lapic)
801027b0:	a1 80 26 11 80       	mov    0x80112680,%eax
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	74 0c                	je     801027c8 <lapicid+0x18>
  return lapic[ID] >> 24;
801027bc:	8b 40 20             	mov    0x20(%eax),%eax
}
801027bf:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
801027c0:	c1 e8 18             	shr    $0x18,%eax
}
801027c3:	c3                   	ret    
801027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801027c8:	31 c0                	xor    %eax,%eax
}
801027ca:	5d                   	pop    %ebp
801027cb:	c3                   	ret    
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <lapiceoi>:
  if(lapic)
801027d0:	a1 80 26 11 80       	mov    0x80112680,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	74 0d                	je     801027e9 <lapiceoi+0x19>
  lapic[index] = value;
801027dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <microdelay>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
}
801027f3:	5d                   	pop    %ebp
801027f4:	c3                   	ret    
801027f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <lapicstartap>:
{
80102800:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102801:	ba 70 00 00 00       	mov    $0x70,%edx
80102806:	89 e5                	mov    %esp,%ebp
80102808:	b8 0f 00 00 00       	mov    $0xf,%eax
8010280d:	53                   	push   %ebx
8010280e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102811:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102814:	ee                   	out    %al,(%dx)
80102815:	b8 0a 00 00 00       	mov    $0xa,%eax
8010281a:	b2 71                	mov    $0x71,%dl
8010281c:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010281d:	31 c0                	xor    %eax,%eax
8010281f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102825:	89 d8                	mov    %ebx,%eax
80102827:	c1 e8 04             	shr    $0x4,%eax
8010282a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102830:	a1 80 26 11 80       	mov    0x80112680,%eax
  lapicw(ICRHI, apicid<<24);
80102835:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102838:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010283b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010284b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102858:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102867:	89 da                	mov    %ebx,%edx
80102869:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010286c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102872:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102875:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010287e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 40 20             	mov    0x20(%eax),%eax
}
80102887:	5b                   	pop    %ebx
80102888:	5d                   	pop    %ebp
80102889:	c3                   	ret    
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102890 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102890:	55                   	push   %ebp
80102891:	ba 70 00 00 00       	mov    $0x70,%edx
80102896:	89 e5                	mov    %esp,%ebp
80102898:	b8 0b 00 00 00       	mov    $0xb,%eax
8010289d:	57                   	push   %edi
8010289e:	56                   	push   %esi
8010289f:	53                   	push   %ebx
801028a0:	83 ec 4c             	sub    $0x4c,%esp
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	b2 71                	mov    $0x71,%dl
801028a6:	ec                   	in     (%dx),%al
801028a7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028aa:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028ad:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028b1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028bd:	89 d8                	mov    %ebx,%eax
801028bf:	e8 7c fd ff ff       	call   80102640 <fill_rtcdate>
801028c4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c9:	89 f2                	mov    %esi,%edx
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	ba 71 00 00 00       	mov    $0x71,%edx
801028d1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d2:	84 c0                	test   %al,%al
801028d4:	78 e7                	js     801028bd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028d6:	89 f8                	mov    %edi,%eax
801028d8:	e8 63 fd ff ff       	call   80102640 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028dd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028e4:	00 
801028e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028e9:	89 1c 24             	mov    %ebx,(%esp)
801028ec:	e8 af 1a 00 00       	call   801043a0 <memcmp>
801028f1:	85 c0                	test   %eax,%eax
801028f3:	75 c3                	jne    801028b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028f5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028f9:	75 78                	jne    80102973 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010290f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102923:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102926:	89 c2                	mov    %eax,%edx
80102928:	83 e0 0f             	and    $0xf,%eax
8010292b:	c1 ea 04             	shr    $0x4,%edx
8010292e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102931:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102934:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 c2                	mov    %eax,%edx
8010293c:	83 e0 0f             	and    $0xf,%eax
8010293f:	c1 ea 04             	shr    $0x4,%edx
80102942:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102945:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102948:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010294b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294e:	89 c2                	mov    %eax,%edx
80102950:	83 e0 0f             	and    $0xf,%eax
80102953:	c1 ea 04             	shr    $0x4,%edx
80102956:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102959:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010295f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102962:	89 c2                	mov    %eax,%edx
80102964:	83 e0 0f             	and    $0xf,%eax
80102967:	c1 ea 04             	shr    $0x4,%edx
8010296a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102970:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102973:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102976:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102979:	89 01                	mov    %eax,(%ecx)
8010297b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010297e:	89 41 04             	mov    %eax,0x4(%ecx)
80102981:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102984:	89 41 08             	mov    %eax,0x8(%ecx)
80102987:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010298d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102990:	89 41 10             	mov    %eax,0x10(%ecx)
80102993:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102996:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102999:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029a0:	83 c4 4c             	add    $0x4c,%esp
801029a3:	5b                   	pop    %ebx
801029a4:	5e                   	pop    %esi
801029a5:	5f                   	pop    %edi
801029a6:	5d                   	pop    %ebp
801029a7:	c3                   	ret    
801029a8:	66 90                	xchg   %ax,%ax
801029aa:	66 90                	xchg   %ax,%ax
801029ac:	66 90                	xchg   %ax,%ax
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	57                   	push   %edi
801029b4:	56                   	push   %esi
801029b5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029b6:	31 db                	xor    %ebx,%ebx
{
801029b8:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801029bb:	a1 e8 26 11 80       	mov    0x801126e8,%eax
801029c0:	85 c0                	test   %eax,%eax
801029c2:	7e 78                	jle    80102a3c <install_trans+0x8c>
801029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029c8:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801029cd:	01 d8                	add    %ebx,%eax
801029cf:	83 c0 01             	add    $0x1,%eax
801029d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d6:	a1 e4 26 11 80       	mov    0x801126e4,%eax
801029db:	89 04 24             	mov    %eax,(%esp)
801029de:	e8 ed d6 ff ff       	call   801000d0 <bread>
801029e3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029e5:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f3:	a1 e4 26 11 80       	mov    0x801126e4,%eax
801029f8:	89 04 24             	mov    %eax,(%esp)
801029fb:	e8 d0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a00:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a07:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a08:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a0a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a11:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a14:	89 04 24             	mov    %eax,(%esp)
80102a17:	e8 d4 19 00 00       	call   801043f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a1c:	89 34 24             	mov    %esi,(%esp)
80102a1f:	e8 7c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a24:	89 3c 24             	mov    %edi,(%esp)
80102a27:	e8 b4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a2c:	89 34 24             	mov    %esi,(%esp)
80102a2f:	e8 ac d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a34:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a3a:	7f 8c                	jg     801029c8 <install_trans+0x18>
  }
}
80102a3c:	83 c4 1c             	add    $0x1c,%esp
80102a3f:	5b                   	pop    %ebx
80102a40:	5e                   	pop    %esi
80102a41:	5f                   	pop    %edi
80102a42:	5d                   	pop    %ebp
80102a43:	c3                   	ret    
80102a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	57                   	push   %edi
80102a54:	56                   	push   %esi
80102a55:	53                   	push   %ebx
80102a56:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a59:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a62:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a67:	89 04 24             	mov    %eax,(%esp)
80102a6a:	e8 61 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a6f:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a75:	31 d2                	xor    %edx,%edx
80102a77:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a79:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a7b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a7e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a81:	7e 17                	jle    80102a9a <write_head+0x4a>
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a88:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102a8f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a93:	83 c2 01             	add    $0x1,%edx
80102a96:	39 da                	cmp    %ebx,%edx
80102a98:	75 ee                	jne    80102a88 <write_head+0x38>
  }
  bwrite(buf);
80102a9a:	89 3c 24             	mov    %edi,(%esp)
80102a9d:	e8 fe d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aa2:	89 3c 24             	mov    %edi,(%esp)
80102aa5:	e8 36 d7 ff ff       	call   801001e0 <brelse>
}
80102aaa:	83 c4 1c             	add    $0x1c,%esp
80102aad:	5b                   	pop    %ebx
80102aae:	5e                   	pop    %esi
80102aaf:	5f                   	pop    %edi
80102ab0:	5d                   	pop    %ebp
80102ab1:	c3                   	ret    
80102ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <initlog>:
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	56                   	push   %esi
80102ac4:	53                   	push   %ebx
80102ac5:	83 ec 30             	sub    $0x30,%esp
80102ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102acb:	c7 44 24 04 60 71 10 	movl   $0x80107160,0x4(%esp)
80102ad2:	80 
80102ad3:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ada:	e8 41 16 00 00       	call   80104120 <initlock>
  readsb(dev, &sb);
80102adf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ae6:	89 1c 24             	mov    %ebx,(%esp)
80102ae9:	e8 32 e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
80102aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102af1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102af4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102af7:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  struct buf *buf = bread(log.dev, log.start);
80102afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102b01:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.start = sb.logstart;
80102b07:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  struct buf *buf = bread(log.dev, log.start);
80102b0c:	e8 bf d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102b11:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102b13:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b16:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b19:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b1b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b21:	7e 17                	jle    80102b3a <initlog+0x7a>
80102b23:	90                   	nop
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b28:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b2c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b33:	83 c2 01             	add    $0x1,%edx
80102b36:	39 da                	cmp    %ebx,%edx
80102b38:	75 ee                	jne    80102b28 <initlog+0x68>
  brelse(buf);
80102b3a:	89 04 24             	mov    %eax,(%esp)
80102b3d:	e8 9e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b42:	e8 69 fe ff ff       	call   801029b0 <install_trans>
  log.lh.n = 0;
80102b47:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b4e:	00 00 00 
  write_head(); // clear the log
80102b51:	e8 fa fe ff ff       	call   80102a50 <write_head>
}
80102b56:	83 c4 30             	add    $0x30,%esp
80102b59:	5b                   	pop    %ebx
80102b5a:	5e                   	pop    %esi
80102b5b:	5d                   	pop    %ebp
80102b5c:	c3                   	ret    
80102b5d:	8d 76 00             	lea    0x0(%esi),%esi

80102b60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b66:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b6d:	e8 1e 17 00 00       	call   80104290 <acquire>
80102b72:	eb 18                	jmp    80102b8c <begin_op+0x2c>
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b78:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102b7f:	80 
80102b80:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b87:	e8 c4 10 00 00       	call   80103c50 <sleep>
    if(log.committing){
80102b8c:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102b91:	85 c0                	test   %eax,%eax
80102b93:	75 e3                	jne    80102b78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b95:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102b9a:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102ba0:	83 c0 01             	add    $0x1,%eax
80102ba3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ba6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102ba9:	83 fa 1e             	cmp    $0x1e,%edx
80102bac:	7f ca                	jg     80102b78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bae:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      log.outstanding += 1;
80102bb5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102bba:	e8 41 17 00 00       	call   80104300 <release>
      break;
    }
  }
}
80102bbf:	c9                   	leave  
80102bc0:	c3                   	ret    
80102bc1:	eb 0d                	jmp    80102bd0 <end_op>
80102bc3:	90                   	nop
80102bc4:	90                   	nop
80102bc5:	90                   	nop
80102bc6:	90                   	nop
80102bc7:	90                   	nop
80102bc8:	90                   	nop
80102bc9:	90                   	nop
80102bca:	90                   	nop
80102bcb:	90                   	nop
80102bcc:	90                   	nop
80102bcd:	90                   	nop
80102bce:	90                   	nop
80102bcf:	90                   	nop

80102bd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	57                   	push   %edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bd9:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102be0:	e8 ab 16 00 00       	call   80104290 <acquire>
  log.outstanding -= 1;
80102be5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102bea:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
  log.outstanding -= 1;
80102bf0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bf3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bf5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102bfa:	0f 85 f3 00 00 00    	jne    80102cf3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c00:	85 c0                	test   %eax,%eax
80102c02:	0f 85 cb 00 00 00    	jne    80102cd3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c08:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c0f:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102c11:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c18:	00 00 00 
  release(&log.lock);
80102c1b:	e8 e0 16 00 00       	call   80104300 <release>
  if (log.lh.n > 0) {
80102c20:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c25:	85 c0                	test   %eax,%eax
80102c27:	0f 8e 90 00 00 00    	jle    80102cbd <end_op+0xed>
80102c2d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c30:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c35:	01 d8                	add    %ebx,%eax
80102c37:	83 c0 01             	add    $0x1,%eax
80102c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c3e:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c43:	89 04 24             	mov    %eax,(%esp)
80102c46:	e8 85 d4 ff ff       	call   801000d0 <bread>
80102c4b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c4d:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c54:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c57:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5b:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c60:	89 04 24             	mov    %eax,(%esp)
80102c63:	e8 68 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c68:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c6f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c70:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c72:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c75:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c79:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c7c:	89 04 24             	mov    %eax,(%esp)
80102c7f:	e8 6c 17 00 00       	call   801043f0 <memmove>
    bwrite(to);  // write the log
80102c84:	89 34 24             	mov    %esi,(%esp)
80102c87:	e8 14 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c8c:	89 3c 24             	mov    %edi,(%esp)
80102c8f:	e8 4c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c94:	89 34 24             	mov    %esi,(%esp)
80102c97:	e8 44 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102ca2:	7c 8c                	jl     80102c30 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ca4:	e8 a7 fd ff ff       	call   80102a50 <write_head>
    install_trans(); // Now install writes to home locations
80102ca9:	e8 02 fd ff ff       	call   801029b0 <install_trans>
    log.lh.n = 0;
80102cae:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102cb5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cb8:	e8 93 fd ff ff       	call   80102a50 <write_head>
    acquire(&log.lock);
80102cbd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cc4:	e8 c7 15 00 00       	call   80104290 <acquire>
    log.committing = 0;
80102cc9:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102cd0:	00 00 00 
    wakeup(&log);
80102cd3:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cda:	e8 01 11 00 00       	call   80103de0 <wakeup>
    release(&log.lock);
80102cdf:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ce6:	e8 15 16 00 00       	call   80104300 <release>
}
80102ceb:	83 c4 1c             	add    $0x1c,%esp
80102cee:	5b                   	pop    %ebx
80102cef:	5e                   	pop    %esi
80102cf0:	5f                   	pop    %edi
80102cf1:	5d                   	pop    %ebp
80102cf2:	c3                   	ret    
    panic("log.committing");
80102cf3:	c7 04 24 64 71 10 80 	movl   $0x80107164,(%esp)
80102cfa:	e8 61 d6 ff ff       	call   80100360 <panic>
80102cff:	90                   	nop

80102d00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d07:	a1 e8 26 11 80       	mov    0x801126e8,%eax
{
80102d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d0f:	83 f8 1d             	cmp    $0x1d,%eax
80102d12:	0f 8f 98 00 00 00    	jg     80102db0 <log_write+0xb0>
80102d18:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102d1e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d21:	39 d0                	cmp    %edx,%eax
80102d23:	0f 8d 87 00 00 00    	jge    80102db0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d29:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	0f 8e 86 00 00 00    	jle    80102dbc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d36:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d3d:	e8 4e 15 00 00       	call   80104290 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d42:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d48:	83 fa 00             	cmp    $0x0,%edx
80102d4b:	7e 54                	jle    80102da1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d4d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d50:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d52:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102d58:	75 0f                	jne    80102d69 <log_write+0x69>
80102d5a:	eb 3c                	jmp    80102d98 <log_write+0x98>
80102d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d60:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102d67:	74 2f                	je     80102d98 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d69:	83 c0 01             	add    $0x1,%eax
80102d6c:	39 d0                	cmp    %edx,%eax
80102d6e:	75 f0                	jne    80102d60 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d70:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d77:	83 c2 01             	add    $0x1,%edx
80102d7a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102d80:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d83:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102d8a:	83 c4 14             	add    $0x14,%esp
80102d8d:	5b                   	pop    %ebx
80102d8e:	5d                   	pop    %ebp
  release(&log.lock);
80102d8f:	e9 6c 15 00 00       	jmp    80104300 <release>
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d98:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102d9f:	eb df                	jmp    80102d80 <log_write+0x80>
80102da1:	8b 43 08             	mov    0x8(%ebx),%eax
80102da4:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102da9:	75 d5                	jne    80102d80 <log_write+0x80>
80102dab:	eb ca                	jmp    80102d77 <log_write+0x77>
80102dad:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102db0:	c7 04 24 73 71 10 80 	movl   $0x80107173,(%esp)
80102db7:	e8 a4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102dbc:	c7 04 24 89 71 10 80 	movl   $0x80107189,(%esp)
80102dc3:	e8 98 d5 ff ff       	call   80100360 <panic>
80102dc8:	66 90                	xchg   %ax,%ax
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102dd7:	e8 f4 08 00 00       	call   801036d0 <cpuid>
80102ddc:	89 c3                	mov    %eax,%ebx
80102dde:	e8 ed 08 00 00       	call   801036d0 <cpuid>
80102de3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102de7:	c7 04 24 a4 71 10 80 	movl   $0x801071a4,(%esp)
80102dee:	89 44 24 04          	mov    %eax,0x4(%esp)
80102df2:	e8 59 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102df7:	e8 64 27 00 00       	call   80105560 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dfc:	e8 4f 08 00 00       	call   80103650 <mycpu>
80102e01:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e03:	b8 01 00 00 00       	mov    $0x1,%eax
80102e08:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e0f:	e8 9c 0b 00 00       	call   801039b0 <scheduler>
80102e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e20 <mpenter>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e26:	e8 f5 37 00 00       	call   80106620 <switchkvm>
  seginit();
80102e2b:	e8 30 37 00 00       	call   80106560 <seginit>
  lapicinit();
80102e30:	e8 8b f8 ff ff       	call   801026c0 <lapicinit>
  mpmain();
80102e35:	e8 96 ff ff ff       	call   80102dd0 <mpmain>
80102e3a:	66 90                	xchg   %ax,%ax
80102e3c:	66 90                	xchg   %ax,%ax
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <main>:
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e44:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
{
80102e49:	83 e4 f0             	and    $0xfffffff0,%esp
80102e4c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e4f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e56:	80 
80102e57:	c7 04 24 c8 54 11 80 	movl   $0x801154c8,(%esp)
80102e5e:	e8 7d f5 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102e63:	e8 48 3c 00 00       	call   80106ab0 <kvmalloc>
  mpinit();        // detect other processors
80102e68:	e8 73 01 00 00       	call   80102fe0 <mpinit>
80102e6d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e70:	e8 4b f8 ff ff       	call   801026c0 <lapicinit>
  seginit();       // segment descriptors
80102e75:	e8 e6 36 00 00       	call   80106560 <seginit>
  picinit();       // disable pic
80102e7a:	e8 21 03 00 00       	call   801031a0 <picinit>
80102e7f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e80:	e8 7b f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102e85:	e8 c6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e8a:	e8 f1 29 00 00       	call   80105880 <uartinit>
80102e8f:	90                   	nop
  pinit();         // process table
80102e90:	e8 9b 07 00 00       	call   80103630 <pinit>
  tvinit();        // trap vectors
80102e95:	e8 26 26 00 00       	call   801054c0 <tvinit>
  binit();         // buffer cache
80102e9a:	e8 a1 d1 ff ff       	call   80100040 <binit>
80102e9f:	90                   	nop
  fileinit();      // file table
80102ea0:	e8 ab de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ea5:	e8 56 f1 ff ff       	call   80102000 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eaa:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102eb1:	00 
80102eb2:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102eb9:	80 
80102eba:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ec1:	e8 2a 15 00 00       	call   801043f0 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102ec6:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102ecd:	00 00 00 
80102ed0:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102ed5:	39 d8                	cmp    %ebx,%eax
80102ed7:	76 6a                	jbe    80102f43 <main+0x103>
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ee0:	e8 6b 07 00 00       	call   80103650 <mycpu>
80102ee5:	39 d8                	cmp    %ebx,%eax
80102ee7:	74 41                	je     80102f2a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ee9:	e8 b2 f5 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102eee:	c7 05 f8 6f 00 80 20 	movl   $0x80102e20,0x80006ff8
80102ef5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ef8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eff:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f02:	05 00 10 00 00       	add    $0x1000,%eax
80102f07:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f0c:	0f b6 03             	movzbl (%ebx),%eax
80102f0f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f16:	00 
80102f17:	89 04 24             	mov    %eax,(%esp)
80102f1a:	e8 e1 f8 ff ff       	call   80102800 <lapicstartap>
80102f1f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f20:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f26:	85 c0                	test   %eax,%eax
80102f28:	74 f6                	je     80102f20 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f2a:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102f31:	00 00 00 
80102f34:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f3a:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f3f:	39 c3                	cmp    %eax,%ebx
80102f41:	72 9d                	jb     80102ee0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f43:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f4a:	8e 
80102f4b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f52:	e8 f9 f4 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80102f57:	e8 c4 07 00 00       	call   80103720 <userinit>
  mpmain();        // finish this processor's setup
80102f5c:	e8 6f fe ff ff       	call   80102dd0 <mpmain>
80102f61:	66 90                	xchg   %ax,%ax
80102f63:	66 90                	xchg   %ax,%ax
80102f65:	66 90                	xchg   %ax,%ax
80102f67:	66 90                	xchg   %ax,%ax
80102f69:	66 90                	xchg   %ax,%ax
80102f6b:	66 90                	xchg   %ax,%ax
80102f6d:	66 90                	xchg   %ax,%ax
80102f6f:	90                   	nop

80102f70 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f74:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f7a:	53                   	push   %ebx
  e = addr+len;
80102f7b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f7e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f81:	39 de                	cmp    %ebx,%esi
80102f83:	73 3c                	jae    80102fc1 <mpsearch1+0x51>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f88:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f8f:	00 
80102f90:	c7 44 24 04 b8 71 10 	movl   $0x801071b8,0x4(%esp)
80102f97:	80 
80102f98:	89 34 24             	mov    %esi,(%esp)
80102f9b:	e8 00 14 00 00       	call   801043a0 <memcmp>
80102fa0:	85 c0                	test   %eax,%eax
80102fa2:	75 16                	jne    80102fba <mpsearch1+0x4a>
80102fa4:	31 c9                	xor    %ecx,%ecx
80102fa6:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102fa8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102fac:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102faf:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102fb1:	83 fa 10             	cmp    $0x10,%edx
80102fb4:	75 f2                	jne    80102fa8 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb6:	84 c9                	test   %cl,%cl
80102fb8:	74 10                	je     80102fca <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102fba:	83 c6 10             	add    $0x10,%esi
80102fbd:	39 f3                	cmp    %esi,%ebx
80102fbf:	77 c7                	ja     80102f88 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102fc1:	83 c4 10             	add    $0x10,%esp
  return 0;
80102fc4:	31 c0                	xor    %eax,%eax
}
80102fc6:	5b                   	pop    %ebx
80102fc7:	5e                   	pop    %esi
80102fc8:	5d                   	pop    %ebp
80102fc9:	c3                   	ret    
80102fca:	83 c4 10             	add    $0x10,%esp
80102fcd:	89 f0                	mov    %esi,%eax
80102fcf:	5b                   	pop    %ebx
80102fd0:	5e                   	pop    %esi
80102fd1:	5d                   	pop    %ebp
80102fd2:	c3                   	ret    
80102fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fe9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ff0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ff7:	c1 e0 08             	shl    $0x8,%eax
80102ffa:	09 d0                	or     %edx,%eax
80102ffc:	c1 e0 04             	shl    $0x4,%eax
80102fff:	85 c0                	test   %eax,%eax
80103001:	75 1b                	jne    8010301e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103003:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010300a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103011:	c1 e0 08             	shl    $0x8,%eax
80103014:	09 d0                	or     %edx,%eax
80103016:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103019:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010301e:	ba 00 04 00 00       	mov    $0x400,%edx
80103023:	e8 48 ff ff ff       	call   80102f70 <mpsearch1>
80103028:	85 c0                	test   %eax,%eax
8010302a:	89 c7                	mov    %eax,%edi
8010302c:	0f 84 22 01 00 00    	je     80103154 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103032:	8b 77 04             	mov    0x4(%edi),%esi
80103035:	85 f6                	test   %esi,%esi
80103037:	0f 84 30 01 00 00    	je     8010316d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010303d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103043:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010304a:	00 
8010304b:	c7 44 24 04 bd 71 10 	movl   $0x801071bd,0x4(%esp)
80103052:	80 
80103053:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103056:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103059:	e8 42 13 00 00       	call   801043a0 <memcmp>
8010305e:	85 c0                	test   %eax,%eax
80103060:	0f 85 07 01 00 00    	jne    8010316d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103066:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010306d:	3c 04                	cmp    $0x4,%al
8010306f:	0f 85 0b 01 00 00    	jne    80103180 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103075:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010307c:	85 c0                	test   %eax,%eax
8010307e:	74 21                	je     801030a1 <mpinit+0xc1>
  sum = 0;
80103080:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103082:	31 d2                	xor    %edx,%edx
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103088:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010308f:	80 
  for(i=0; i<len; i++)
80103090:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103093:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103095:	39 d0                	cmp    %edx,%eax
80103097:	7f ef                	jg     80103088 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103099:	84 c9                	test   %cl,%cl
8010309b:	0f 85 cc 00 00 00    	jne    8010316d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a4:	85 c0                	test   %eax,%eax
801030a6:	0f 84 c1 00 00 00    	je     8010316d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030ac:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
801030b2:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
801030b7:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030bc:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030c3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030c9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030d0:	39 c2                	cmp    %eax,%edx
801030d2:	76 1b                	jbe    801030ef <mpinit+0x10f>
801030d4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030d7:	80 f9 04             	cmp    $0x4,%cl
801030da:	77 74                	ja     80103150 <mpinit+0x170>
801030dc:	ff 24 8d fc 71 10 80 	jmp    *-0x7fef8e04(,%ecx,4)
801030e3:	90                   	nop
801030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030e8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030eb:	39 c2                	cmp    %eax,%edx
801030ed:	77 e5                	ja     801030d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030ef:	85 db                	test   %ebx,%ebx
801030f1:	0f 84 93 00 00 00    	je     8010318a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030f7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030fb:	74 12                	je     8010310f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fd:	ba 22 00 00 00       	mov    $0x22,%edx
80103102:	b8 70 00 00 00       	mov    $0x70,%eax
80103107:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103108:	b2 23                	mov    $0x23,%dl
8010310a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010310b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310e:	ee                   	out    %al,(%dx)
  }
}
8010310f:	83 c4 1c             	add    $0x1c,%esp
80103112:	5b                   	pop    %ebx
80103113:	5e                   	pop    %esi
80103114:	5f                   	pop    %edi
80103115:	5d                   	pop    %ebp
80103116:	c3                   	ret    
80103117:	90                   	nop
      if(ncpu < NCPU) {
80103118:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
8010311e:	83 fe 07             	cmp    $0x7,%esi
80103121:	7f 17                	jg     8010313a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103123:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103127:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010312d:	83 05 20 2d 11 80 01 	addl   $0x1,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103134:	88 8e a0 27 11 80    	mov    %cl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
8010313a:	83 c0 14             	add    $0x14,%eax
      continue;
8010313d:	eb 91                	jmp    801030d0 <mpinit+0xf0>
8010313f:	90                   	nop
      ioapicid = ioapic->apicno;
80103140:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103144:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103147:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010314d:	eb 81                	jmp    801030d0 <mpinit+0xf0>
8010314f:	90                   	nop
      ismp = 0;
80103150:	31 db                	xor    %ebx,%ebx
80103152:	eb 83                	jmp    801030d7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103154:	ba 00 00 01 00       	mov    $0x10000,%edx
80103159:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010315e:	e8 0d fe ff ff       	call   80102f70 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103163:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103165:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103167:	0f 85 c5 fe ff ff    	jne    80103032 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010316d:	c7 04 24 c2 71 10 80 	movl   $0x801071c2,(%esp)
80103174:	e8 e7 d1 ff ff       	call   80100360 <panic>
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103180:	3c 01                	cmp    $0x1,%al
80103182:	0f 84 ed fe ff ff    	je     80103075 <mpinit+0x95>
80103188:	eb e3                	jmp    8010316d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010318a:	c7 04 24 dc 71 10 80 	movl   $0x801071dc,(%esp)
80103191:	e8 ca d1 ff ff       	call   80100360 <panic>
80103196:	66 90                	xchg   %ax,%ax
80103198:	66 90                	xchg   %ax,%ax
8010319a:	66 90                	xchg   %ax,%ax
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031a0:	55                   	push   %ebp
801031a1:	ba 21 00 00 00       	mov    $0x21,%edx
801031a6:	89 e5                	mov    %esp,%ebp
801031a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031ad:	ee                   	out    %al,(%dx)
801031ae:	b2 a1                	mov    $0xa1,%dl
801031b0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031b1:	5d                   	pop    %ebp
801031b2:	c3                   	ret    
801031b3:	66 90                	xchg   %ax,%ax
801031b5:	66 90                	xchg   %ax,%ax
801031b7:	66 90                	xchg   %ax,%ax
801031b9:	66 90                	xchg   %ax,%ax
801031bb:	66 90                	xchg   %ax,%ax
801031bd:	66 90                	xchg   %ax,%ax
801031bf:	90                   	nop

801031c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
801031c5:	53                   	push   %ebx
801031c6:	83 ec 1c             	sub    $0x1c,%esp
801031c9:	8b 75 08             	mov    0x8(%ebp),%esi
801031cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031db:	e8 90 db ff ff       	call   80100d70 <filealloc>
801031e0:	85 c0                	test   %eax,%eax
801031e2:	89 06                	mov    %eax,(%esi)
801031e4:	0f 84 a4 00 00 00    	je     8010328e <pipealloc+0xce>
801031ea:	e8 81 db ff ff       	call   80100d70 <filealloc>
801031ef:	85 c0                	test   %eax,%eax
801031f1:	89 03                	mov    %eax,(%ebx)
801031f3:	0f 84 87 00 00 00    	je     80103280 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031f9:	e8 a2 f2 ff ff       	call   801024a0 <kalloc>
801031fe:	85 c0                	test   %eax,%eax
80103200:	89 c7                	mov    %eax,%edi
80103202:	74 7c                	je     80103280 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103204:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010320b:	00 00 00 
  p->writeopen = 1;
8010320e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103215:	00 00 00 
  p->nwrite = 0;
80103218:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010321f:	00 00 00 
  p->nread = 0;
80103222:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103229:	00 00 00 
  initlock(&p->lock, "pipe");
8010322c:	89 04 24             	mov    %eax,(%esp)
8010322f:	c7 44 24 04 10 72 10 	movl   $0x80107210,0x4(%esp)
80103236:	80 
80103237:	e8 e4 0e 00 00       	call   80104120 <initlock>
  (*f0)->type = FD_PIPE;
8010323c:	8b 06                	mov    (%esi),%eax
8010323e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103244:	8b 06                	mov    (%esi),%eax
80103246:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010324a:	8b 06                	mov    (%esi),%eax
8010324c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103250:	8b 06                	mov    (%esi),%eax
80103252:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103255:	8b 03                	mov    (%ebx),%eax
80103257:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010325d:	8b 03                	mov    (%ebx),%eax
8010325f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103263:	8b 03                	mov    (%ebx),%eax
80103265:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103269:	8b 03                	mov    (%ebx),%eax
  return 0;
8010326b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010326d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103270:	83 c4 1c             	add    $0x1c,%esp
80103273:	89 d8                	mov    %ebx,%eax
80103275:	5b                   	pop    %ebx
80103276:	5e                   	pop    %esi
80103277:	5f                   	pop    %edi
80103278:	5d                   	pop    %ebp
80103279:	c3                   	ret    
8010327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103280:	8b 06                	mov    (%esi),%eax
80103282:	85 c0                	test   %eax,%eax
80103284:	74 08                	je     8010328e <pipealloc+0xce>
    fileclose(*f0);
80103286:	89 04 24             	mov    %eax,(%esp)
80103289:	e8 a2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010328e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103290:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103295:	85 c0                	test   %eax,%eax
80103297:	74 d7                	je     80103270 <pipealloc+0xb0>
    fileclose(*f1);
80103299:	89 04 24             	mov    %eax,(%esp)
8010329c:	e8 8f db ff ff       	call   80100e30 <fileclose>
}
801032a1:	83 c4 1c             	add    $0x1c,%esp
801032a4:	89 d8                	mov    %ebx,%eax
801032a6:	5b                   	pop    %ebx
801032a7:	5e                   	pop    %esi
801032a8:	5f                   	pop    %edi
801032a9:	5d                   	pop    %ebp
801032aa:	c3                   	ret    
801032ab:	90                   	nop
801032ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	56                   	push   %esi
801032b4:	53                   	push   %ebx
801032b5:	83 ec 10             	sub    $0x10,%esp
801032b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032be:	89 1c 24             	mov    %ebx,(%esp)
801032c1:	e8 ca 0f 00 00       	call   80104290 <acquire>
  if(writable){
801032c6:	85 f6                	test   %esi,%esi
801032c8:	74 3e                	je     80103308 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032ca:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032d0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032d7:	00 00 00 
    wakeup(&p->nread);
801032da:	89 04 24             	mov    %eax,(%esp)
801032dd:	e8 fe 0a 00 00       	call   80103de0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032e2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032e8:	85 d2                	test   %edx,%edx
801032ea:	75 0a                	jne    801032f6 <pipeclose+0x46>
801032ec:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 32                	je     80103328 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032f9:	83 c4 10             	add    $0x10,%esp
801032fc:	5b                   	pop    %ebx
801032fd:	5e                   	pop    %esi
801032fe:	5d                   	pop    %ebp
    release(&p->lock);
801032ff:	e9 fc 0f 00 00       	jmp    80104300 <release>
80103304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103308:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
8010330e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103315:	00 00 00 
    wakeup(&p->nwrite);
80103318:	89 04 24             	mov    %eax,(%esp)
8010331b:	e8 c0 0a 00 00       	call   80103de0 <wakeup>
80103320:	eb c0                	jmp    801032e2 <pipeclose+0x32>
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
80103328:	89 1c 24             	mov    %ebx,(%esp)
8010332b:	e8 d0 0f 00 00       	call   80104300 <release>
    kfree((char*)p);
80103330:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103333:	83 c4 10             	add    $0x10,%esp
80103336:	5b                   	pop    %ebx
80103337:	5e                   	pop    %esi
80103338:	5d                   	pop    %ebp
    kfree((char*)p);
80103339:	e9 b2 ef ff ff       	jmp    801022f0 <kfree>
8010333e:	66 90                	xchg   %ax,%ax

80103340 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 1c             	sub    $0x1c,%esp
80103349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010334c:	89 1c 24             	mov    %ebx,(%esp)
8010334f:	e8 3c 0f 00 00       	call   80104290 <acquire>
  for(i = 0; i < n; i++){
80103354:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103357:	85 c9                	test   %ecx,%ecx
80103359:	0f 8e b2 00 00 00    	jle    80103411 <pipewrite+0xd1>
8010335f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103362:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103368:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010336e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103374:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103377:	03 4d 10             	add    0x10(%ebp),%ecx
8010337a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010337d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103383:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103389:	39 c8                	cmp    %ecx,%eax
8010338b:	74 38                	je     801033c5 <pipewrite+0x85>
8010338d:	eb 55                	jmp    801033e4 <pipewrite+0xa4>
8010338f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103390:	e8 5b 03 00 00       	call   801036f0 <myproc>
80103395:	8b 40 24             	mov    0x24(%eax),%eax
80103398:	85 c0                	test   %eax,%eax
8010339a:	75 33                	jne    801033cf <pipewrite+0x8f>
      wakeup(&p->nread);
8010339c:	89 3c 24             	mov    %edi,(%esp)
8010339f:	e8 3c 0a 00 00       	call   80103de0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033a8:	89 34 24             	mov    %esi,(%esp)
801033ab:	e8 a0 08 00 00       	call   80103c50 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033b0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033b6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033bc:	05 00 02 00 00       	add    $0x200,%eax
801033c1:	39 c2                	cmp    %eax,%edx
801033c3:	75 23                	jne    801033e8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033c5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cb:	85 d2                	test   %edx,%edx
801033cd:	75 c1                	jne    80103390 <pipewrite+0x50>
        release(&p->lock);
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 29 0f 00 00       	call   80104300 <release>
        return -1;
801033d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033dc:	83 c4 1c             	add    $0x1c,%esp
801033df:	5b                   	pop    %ebx
801033e0:	5e                   	pop    %esi
801033e1:	5f                   	pop    %edi
801033e2:	5d                   	pop    %ebp
801033e3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033e4:	89 c2                	mov    %eax,%edx
801033e6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033eb:	8d 42 01             	lea    0x1(%edx),%eax
801033ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033f4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033fe:	0f b6 09             	movzbl (%ecx),%ecx
80103401:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103405:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103408:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010340b:	0f 85 6c ff ff ff    	jne    8010337d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103411:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103417:	89 04 24             	mov    %eax,(%esp)
8010341a:	e8 c1 09 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
8010341f:	89 1c 24             	mov    %ebx,(%esp)
80103422:	e8 d9 0e 00 00       	call   80104300 <release>
  return n;
80103427:	8b 45 10             	mov    0x10(%ebp),%eax
8010342a:	eb b0                	jmp    801033dc <pipewrite+0x9c>
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103430 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 1c             	sub    $0x1c,%esp
80103439:	8b 75 08             	mov    0x8(%ebp),%esi
8010343c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010343f:	89 34 24             	mov    %esi,(%esp)
80103442:	e8 49 0e 00 00       	call   80104290 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103447:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010344d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103453:	75 5b                	jne    801034b0 <piperead+0x80>
80103455:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010345b:	85 db                	test   %ebx,%ebx
8010345d:	74 51                	je     801034b0 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010345f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103465:	eb 25                	jmp    8010348c <piperead+0x5c>
80103467:	90                   	nop
80103468:	89 74 24 04          	mov    %esi,0x4(%esp)
8010346c:	89 1c 24             	mov    %ebx,(%esp)
8010346f:	e8 dc 07 00 00       	call   80103c50 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103474:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010347a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103480:	75 2e                	jne    801034b0 <piperead+0x80>
80103482:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103488:	85 d2                	test   %edx,%edx
8010348a:	74 24                	je     801034b0 <piperead+0x80>
    if(myproc()->killed){
8010348c:	e8 5f 02 00 00       	call   801036f0 <myproc>
80103491:	8b 48 24             	mov    0x24(%eax),%ecx
80103494:	85 c9                	test   %ecx,%ecx
80103496:	74 d0                	je     80103468 <piperead+0x38>
      release(&p->lock);
80103498:	89 34 24             	mov    %esi,(%esp)
8010349b:	e8 60 0e 00 00       	call   80104300 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034a0:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801034a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034a8:	5b                   	pop    %ebx
801034a9:	5e                   	pop    %esi
801034aa:	5f                   	pop    %edi
801034ab:	5d                   	pop    %ebp
801034ac:	c3                   	ret    
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801034b3:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b5:	85 d2                	test   %edx,%edx
801034b7:	7f 2b                	jg     801034e4 <piperead+0xb4>
801034b9:	eb 31                	jmp    801034ec <piperead+0xbc>
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034c0:	8d 48 01             	lea    0x1(%eax),%ecx
801034c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034d6:	83 c3 01             	add    $0x1,%ebx
801034d9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034dc:	74 0e                	je     801034ec <piperead+0xbc>
    if(p->nread == p->nwrite)
801034de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ea:	75 d4                	jne    801034c0 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ec:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034f2:	89 04 24             	mov    %eax,(%esp)
801034f5:	e8 e6 08 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
801034fa:	89 34 24             	mov    %esi,(%esp)
801034fd:	e8 fe 0d 00 00       	call   80104300 <release>
}
80103502:	83 c4 1c             	add    $0x1c,%esp
  return i;
80103505:	89 d8                	mov    %ebx,%eax
}
80103507:	5b                   	pop    %ebx
80103508:	5e                   	pop    %esi
80103509:	5f                   	pop    %edi
8010350a:	5d                   	pop    %ebp
8010350b:	c3                   	ret    
8010350c:	66 90                	xchg   %ax,%ax
8010350e:	66 90                	xchg   %ax,%ax

80103510 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103514:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103519:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010351c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103523:	e8 68 0d 00 00       	call   80104290 <acquire>
80103528:	eb 11                	jmp    8010353b <allocproc+0x2b>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103530:	83 c3 7c             	add    $0x7c,%ebx
80103533:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103539:	74 7d                	je     801035b8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010353b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010353e:	85 c0                	test   %eax,%eax
80103540:	75 ee                	jne    80103530 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103542:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103547:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
  p->state = EMBRYO;
8010354e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103555:	8d 50 01             	lea    0x1(%eax),%edx
80103558:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010355e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103561:	e8 9a 0d 00 00       	call   80104300 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103566:	e8 35 ef ff ff       	call   801024a0 <kalloc>
8010356b:	85 c0                	test   %eax,%eax
8010356d:	89 43 08             	mov    %eax,0x8(%ebx)
80103570:	74 5a                	je     801035cc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103572:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103578:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010357d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103580:	c7 40 14 ae 54 10 80 	movl   $0x801054ae,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103587:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010358e:	00 
8010358f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103596:	00 
80103597:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010359a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010359d:	e8 ae 0d 00 00       	call   80104350 <memset>
  p->context->eip = (uint)forkret;
801035a2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035a5:	c7 40 10 e0 35 10 80 	movl   $0x801035e0,0x10(%eax)

  return p;
801035ac:	89 d8                	mov    %ebx,%eax
}
801035ae:	83 c4 14             	add    $0x14,%esp
801035b1:	5b                   	pop    %ebx
801035b2:	5d                   	pop    %ebp
801035b3:	c3                   	ret    
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801035b8:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801035bf:	e8 3c 0d 00 00       	call   80104300 <release>
}
801035c4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035c7:	31 c0                	xor    %eax,%eax
}
801035c9:	5b                   	pop    %ebx
801035ca:	5d                   	pop    %ebp
801035cb:	c3                   	ret    
    p->state = UNUSED;
801035cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035d3:	eb d9                	jmp    801035ae <allocproc+0x9e>
801035d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035e6:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801035ed:	e8 0e 0d 00 00       	call   80104300 <release>

  if (first) {
801035f2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	75 05                	jne    80103600 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035fb:	c9                   	leave  
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
80103600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103607:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010360e:	00 00 00 
    iinit(ROOTDEV);
80103611:	e8 5a de ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103616:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010361d:	e8 9e f4 ff ff       	call   80102ac0 <initlog>
}
80103622:	c9                   	leave  
80103623:	c3                   	ret    
80103624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010362a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103630 <pinit>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103636:	c7 44 24 04 15 72 10 	movl   $0x80107215,0x4(%esp)
8010363d:	80 
8010363e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103645:	e8 d6 0a 00 00       	call   80104120 <initlock>
}
8010364a:	c9                   	leave  
8010364b:	c3                   	ret    
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103650 <mycpu>:
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	56                   	push   %esi
80103654:	53                   	push   %ebx
80103655:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103658:	9c                   	pushf  
80103659:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010365a:	f6 c4 02             	test   $0x2,%ah
8010365d:	75 57                	jne    801036b6 <mycpu+0x66>
  apicid = lapicid();
8010365f:	e8 4c f1 ff ff       	call   801027b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103664:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
8010366a:	85 f6                	test   %esi,%esi
8010366c:	7e 3c                	jle    801036aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010366e:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103675:	39 c2                	cmp    %eax,%edx
80103677:	74 2d                	je     801036a6 <mycpu+0x56>
80103679:	b9 50 28 11 80       	mov    $0x80112850,%ecx
  for (i = 0; i < ncpu; ++i) {
8010367e:	31 d2                	xor    %edx,%edx
80103680:	83 c2 01             	add    $0x1,%edx
80103683:	39 f2                	cmp    %esi,%edx
80103685:	74 23                	je     801036aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103687:	0f b6 19             	movzbl (%ecx),%ebx
8010368a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103690:	39 c3                	cmp    %eax,%ebx
80103692:	75 ec                	jne    80103680 <mycpu+0x30>
      return &cpus[i];
80103694:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5d                   	pop    %ebp
      return &cpus[i];
801036a0:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
801036a5:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
801036a6:	31 d2                	xor    %edx,%edx
801036a8:	eb ea                	jmp    80103694 <mycpu+0x44>
  panic("unknown apicid\n");
801036aa:	c7 04 24 1c 72 10 80 	movl   $0x8010721c,(%esp)
801036b1:	e8 aa cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036b6:	c7 04 24 f8 72 10 80 	movl   $0x801072f8,(%esp)
801036bd:	e8 9e cc ff ff       	call   80100360 <panic>
801036c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036d0 <cpuid>:
cpuid() {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036d6:	e8 75 ff ff ff       	call   80103650 <mycpu>
}
801036db:	c9                   	leave  
  return mycpu()-cpus;
801036dc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801036e1:	c1 f8 04             	sar    $0x4,%eax
801036e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ea:	c3                   	ret    
801036eb:	90                   	nop
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <myproc>:
myproc(void) {
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036f7:	e8 a4 0a 00 00       	call   801041a0 <pushcli>
  c = mycpu();
801036fc:	e8 4f ff ff ff       	call   80103650 <mycpu>
  p = c->proc;
80103701:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103707:	e8 d4 0a 00 00       	call   801041e0 <popcli>
}
8010370c:	83 c4 04             	add    $0x4,%esp
8010370f:	89 d8                	mov    %ebx,%eax
80103711:	5b                   	pop    %ebx
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    
80103714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010371a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103720 <userinit>:
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
80103724:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103727:	e8 e4 fd ff ff       	call   80103510 <allocproc>
8010372c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010372e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103733:	e8 e8 32 00 00       	call   80106a20 <setupkvm>
80103738:	85 c0                	test   %eax,%eax
8010373a:	89 43 04             	mov    %eax,0x4(%ebx)
8010373d:	0f 84 d4 00 00 00    	je     80103817 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103743:	89 04 24             	mov    %eax,(%esp)
80103746:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010374d:	00 
8010374e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103755:	80 
80103756:	e8 f5 2f 00 00       	call   80106750 <inituvm>
  p->sz = PGSIZE;
8010375b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103761:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103768:	00 
80103769:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103770:	00 
80103771:	8b 43 18             	mov    0x18(%ebx),%eax
80103774:	89 04 24             	mov    %eax,(%esp)
80103777:	e8 d4 0b 00 00       	call   80104350 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010377c:	8b 43 18             	mov    0x18(%ebx),%eax
8010377f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103784:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103789:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010378d:	8b 43 18             	mov    0x18(%ebx),%eax
80103790:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103794:	8b 43 18             	mov    0x18(%ebx),%eax
80103797:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010379b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010379f:	8b 43 18             	mov    0x18(%ebx),%eax
801037a2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037a6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037aa:	8b 43 18             	mov    0x18(%ebx),%eax
801037ad:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037b4:	8b 43 18             	mov    0x18(%ebx),%eax
801037b7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037be:	8b 43 18             	mov    0x18(%ebx),%eax
801037c1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037c8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037d2:	00 
801037d3:	c7 44 24 04 45 72 10 	movl   $0x80107245,0x4(%esp)
801037da:	80 
801037db:	89 04 24             	mov    %eax,(%esp)
801037de:	e8 4d 0d 00 00       	call   80104530 <safestrcpy>
  p->cwd = namei("/");
801037e3:	c7 04 24 4e 72 10 80 	movl   $0x8010724e,(%esp)
801037ea:	e8 11 e7 ff ff       	call   80101f00 <namei>
801037ef:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037f2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801037f9:	e8 92 0a 00 00       	call   80104290 <acquire>
  p->state = RUNNABLE;
801037fe:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103805:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010380c:	e8 ef 0a 00 00       	call   80104300 <release>
}
80103811:	83 c4 14             	add    $0x14,%esp
80103814:	5b                   	pop    %ebx
80103815:	5d                   	pop    %ebp
80103816:	c3                   	ret    
    panic("userinit: out of memory?");
80103817:	c7 04 24 2c 72 10 80 	movl   $0x8010722c,(%esp)
8010381e:	e8 3d cb ff ff       	call   80100360 <panic>
80103823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <growproc>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
80103835:	83 ec 10             	sub    $0x10,%esp
80103838:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010383b:	e8 b0 fe ff ff       	call   801036f0 <myproc>
  if(n > 0){
80103840:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103843:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103845:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103847:	7e 2f                	jle    80103878 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103849:	01 c6                	add    %eax,%esi
8010384b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010384f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103853:	8b 43 04             	mov    0x4(%ebx),%eax
80103856:	89 04 24             	mov    %eax,(%esp)
80103859:	e8 32 30 00 00       	call   80106890 <allocuvm>
8010385e:	85 c0                	test   %eax,%eax
80103860:	74 36                	je     80103898 <growproc+0x68>
  curproc->sz = sz;
80103862:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103864:	89 1c 24             	mov    %ebx,(%esp)
80103867:	e8 d4 2d 00 00       	call   80106640 <switchuvm>
  return 0;
8010386c:	31 c0                	xor    %eax,%eax
}
8010386e:	83 c4 10             	add    $0x10,%esp
80103871:	5b                   	pop    %ebx
80103872:	5e                   	pop    %esi
80103873:	5d                   	pop    %ebp
80103874:	c3                   	ret    
80103875:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103878:	74 e8                	je     80103862 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010387a:	01 c6                	add    %eax,%esi
8010387c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103880:	89 44 24 04          	mov    %eax,0x4(%esp)
80103884:	8b 43 04             	mov    0x4(%ebx),%eax
80103887:	89 04 24             	mov    %eax,(%esp)
8010388a:	e8 f1 30 00 00       	call   80106980 <deallocuvm>
8010388f:	85 c0                	test   %eax,%eax
80103891:	75 cf                	jne    80103862 <growproc+0x32>
80103893:	90                   	nop
80103894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010389d:	eb cf                	jmp    8010386e <growproc+0x3e>
8010389f:	90                   	nop

801038a0 <fork>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801038a9:	e8 42 fe ff ff       	call   801036f0 <myproc>
801038ae:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038b0:	e8 5b fc ff ff       	call   80103510 <allocproc>
801038b5:	85 c0                	test   %eax,%eax
801038b7:	89 c7                	mov    %eax,%edi
801038b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038bc:	0f 84 bc 00 00 00    	je     8010397e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038c2:	8b 03                	mov    (%ebx),%eax
801038c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038c8:	8b 43 04             	mov    0x4(%ebx),%eax
801038cb:	89 04 24             	mov    %eax,(%esp)
801038ce:	e8 2d 32 00 00       	call   80106b00 <copyuvm>
801038d3:	85 c0                	test   %eax,%eax
801038d5:	89 47 04             	mov    %eax,0x4(%edi)
801038d8:	0f 84 a7 00 00 00    	je     80103985 <fork+0xe5>
  np->sz = curproc->sz;
801038de:	8b 03                	mov    (%ebx),%eax
801038e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038e3:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038e5:	8b 79 18             	mov    0x18(%ecx),%edi
801038e8:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038ea:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038ed:	8b 73 18             	mov    0x18(%ebx),%esi
801038f0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038f7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038f9:	8b 40 18             	mov    0x18(%eax),%eax
801038fc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103903:	90                   	nop
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103908:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010390c:	85 c0                	test   %eax,%eax
8010390e:	74 0f                	je     8010391f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103910:	89 04 24             	mov    %eax,(%esp)
80103913:	e8 c8 d4 ff ff       	call   80100de0 <filedup>
80103918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010391b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010391f:	83 c6 01             	add    $0x1,%esi
80103922:	83 fe 10             	cmp    $0x10,%esi
80103925:	75 e1                	jne    80103908 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103927:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010392a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010392d:	89 04 24             	mov    %eax,(%esp)
80103930:	e8 4b dd ff ff       	call   80101680 <idup>
80103935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103938:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010393b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010393e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103942:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103949:	00 
8010394a:	89 04 24             	mov    %eax,(%esp)
8010394d:	e8 de 0b 00 00       	call   80104530 <safestrcpy>
  pid = np->pid;
80103952:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103955:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010395c:	e8 2f 09 00 00       	call   80104290 <acquire>
  np->state = RUNNABLE;
80103961:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103968:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010396f:	e8 8c 09 00 00       	call   80104300 <release>
  return pid;
80103974:	89 d8                	mov    %ebx,%eax
}
80103976:	83 c4 1c             	add    $0x1c,%esp
80103979:	5b                   	pop    %ebx
8010397a:	5e                   	pop    %esi
8010397b:	5f                   	pop    %edi
8010397c:	5d                   	pop    %ebp
8010397d:	c3                   	ret    
    return -1;
8010397e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103983:	eb f1                	jmp    80103976 <fork+0xd6>
    kfree(np->kstack);
80103985:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103988:	8b 47 08             	mov    0x8(%edi),%eax
8010398b:	89 04 24             	mov    %eax,(%esp)
8010398e:	e8 5d e9 ff ff       	call   801022f0 <kfree>
    return -1;
80103993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103998:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010399f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801039a6:	eb ce                	jmp    80103976 <fork+0xd6>
801039a8:	90                   	nop
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <scheduler>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801039b9:	e8 92 fc ff ff       	call   80103650 <mycpu>
801039be:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039c0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039c7:	00 00 00 
801039ca:	8d 78 04             	lea    0x4(%eax),%edi
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039d0:	fb                   	sti    
    acquire(&ptable.lock);
801039d1:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d8:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
801039dd:	e8 ae 08 00 00       	call   80104290 <acquire>
801039e2:	eb 0f                	jmp    801039f3 <scheduler+0x43>
801039e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e8:	83 c3 7c             	add    $0x7c,%ebx
801039eb:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801039f1:	74 45                	je     80103a38 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039f3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039f7:	75 ef                	jne    801039e8 <scheduler+0x38>
      c->proc = p;
801039f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039ff:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a02:	83 c3 7c             	add    $0x7c,%ebx
      switchuvm(p);
80103a05:	e8 36 2c 00 00       	call   80106640 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103a0a:	8b 43 a0             	mov    -0x60(%ebx),%eax
      p->state = RUNNING;
80103a0d:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&(c->scheduler), p->context);
80103a14:	89 3c 24             	mov    %edi,(%esp)
80103a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a1b:	e8 6b 0b 00 00       	call   8010458b <swtch>
      switchkvm();
80103a20:	e8 fb 2b 00 00       	call   80106620 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a25:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
      c->proc = 0;
80103a2b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a32:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a35:	75 bc                	jne    801039f3 <scheduler+0x43>
80103a37:	90                   	nop
    release(&ptable.lock);
80103a38:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103a3f:	e8 bc 08 00 00       	call   80104300 <release>
  }
80103a44:	eb 8a                	jmp    801039d0 <scheduler+0x20>
80103a46:	8d 76 00             	lea    0x0(%esi),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <sched>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a58:	e8 93 fc ff ff       	call   801036f0 <myproc>
  if(!holding(&ptable.lock))
80103a5d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
  struct proc *p = myproc();
80103a64:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a66:	e8 e5 07 00 00       	call   80104250 <holding>
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	74 4f                	je     80103abe <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a6f:	e8 dc fb ff ff       	call   80103650 <mycpu>
80103a74:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a7b:	75 65                	jne    80103ae2 <sched+0x92>
  if(p->state == RUNNING)
80103a7d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a81:	74 53                	je     80103ad6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a83:	9c                   	pushf  
80103a84:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a85:	f6 c4 02             	test   $0x2,%ah
80103a88:	75 40                	jne    80103aca <sched+0x7a>
  intena = mycpu()->intena;
80103a8a:	e8 c1 fb ff ff       	call   80103650 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a8f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a92:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a98:	e8 b3 fb ff ff       	call   80103650 <mycpu>
80103a9d:	8b 40 04             	mov    0x4(%eax),%eax
80103aa0:	89 1c 24             	mov    %ebx,(%esp)
80103aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aa7:	e8 df 0a 00 00       	call   8010458b <swtch>
  mycpu()->intena = intena;
80103aac:	e8 9f fb ff ff       	call   80103650 <mycpu>
80103ab1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ab7:	83 c4 10             	add    $0x10,%esp
80103aba:	5b                   	pop    %ebx
80103abb:	5e                   	pop    %esi
80103abc:	5d                   	pop    %ebp
80103abd:	c3                   	ret    
    panic("sched ptable.lock");
80103abe:	c7 04 24 50 72 10 80 	movl   $0x80107250,(%esp)
80103ac5:	e8 96 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103aca:	c7 04 24 7c 72 10 80 	movl   $0x8010727c,(%esp)
80103ad1:	e8 8a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103ad6:	c7 04 24 6e 72 10 80 	movl   $0x8010726e,(%esp)
80103add:	e8 7e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103ae2:	c7 04 24 62 72 10 80 	movl   $0x80107262,(%esp)
80103ae9:	e8 72 c8 ff ff       	call   80100360 <panic>
80103aee:	66 90                	xchg   %ax,%ax

80103af0 <exit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
  if(curproc == initproc)
80103af4:	31 f6                	xor    %esi,%esi
{
80103af6:	53                   	push   %ebx
80103af7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103afa:	e8 f1 fb ff ff       	call   801036f0 <myproc>
  if(curproc == initproc)
80103aff:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103b05:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103b07:	0f 84 ea 00 00 00    	je     80103bf7 <exit+0x107>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b14:	85 c0                	test   %eax,%eax
80103b16:	74 10                	je     80103b28 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b18:	89 04 24             	mov    %eax,(%esp)
80103b1b:	e8 10 d3 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b20:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b27:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b28:	83 c6 01             	add    $0x1,%esi
80103b2b:	83 fe 10             	cmp    $0x10,%esi
80103b2e:	75 e0                	jne    80103b10 <exit+0x20>
  begin_op();
80103b30:	e8 2b f0 ff ff       	call   80102b60 <begin_op>
  iput(curproc->cwd);
80103b35:	8b 43 68             	mov    0x68(%ebx),%eax
80103b38:	89 04 24             	mov    %eax,(%esp)
80103b3b:	e8 90 dc ff ff       	call   801017d0 <iput>
  end_op();
80103b40:	e8 8b f0 ff ff       	call   80102bd0 <end_op>
  curproc->cwd = 0;
80103b45:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b4c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b53:	e8 38 07 00 00       	call   80104290 <acquire>
  wakeup1(curproc->parent);
80103b58:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b5b:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103b60:	eb 11                	jmp    80103b73 <exit+0x83>
80103b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b68:	83 c2 7c             	add    $0x7c,%edx
80103b6b:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
80103b71:	74 1d                	je     80103b90 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b73:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b77:	75 ef                	jne    80103b68 <exit+0x78>
80103b79:	3b 42 20             	cmp    0x20(%edx),%eax
80103b7c:	75 ea                	jne    80103b68 <exit+0x78>
      p->state = RUNNABLE;
80103b7e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b85:	83 c2 7c             	add    $0x7c,%edx
80103b88:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
80103b8e:	75 e3                	jne    80103b73 <exit+0x83>
      p->parent = initproc;
80103b90:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b95:	b9 74 2d 11 80       	mov    $0x80112d74,%ecx
80103b9a:	eb 0f                	jmp    80103bab <exit+0xbb>
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba0:	83 c1 7c             	add    $0x7c,%ecx
80103ba3:	81 f9 74 4c 11 80    	cmp    $0x80114c74,%ecx
80103ba9:	74 34                	je     80103bdf <exit+0xef>
    if(p->parent == curproc){
80103bab:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103bae:	75 f0                	jne    80103ba0 <exit+0xb0>
      if(p->state == ZOMBIE)
80103bb0:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103bb4:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103bb7:	75 e7                	jne    80103ba0 <exit+0xb0>
80103bb9:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103bbe:	eb 0b                	jmp    80103bcb <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bc0:	83 c2 7c             	add    $0x7c,%edx
80103bc3:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
80103bc9:	74 d5                	je     80103ba0 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103bcb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bcf:	75 ef                	jne    80103bc0 <exit+0xd0>
80103bd1:	3b 42 20             	cmp    0x20(%edx),%eax
80103bd4:	75 ea                	jne    80103bc0 <exit+0xd0>
      p->state = RUNNABLE;
80103bd6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bdd:	eb e1                	jmp    80103bc0 <exit+0xd0>
  curproc->state = ZOMBIE;
80103bdf:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103be6:	e8 65 fe ff ff       	call   80103a50 <sched>
  panic("zombie exit");
80103beb:	c7 04 24 9d 72 10 80 	movl   $0x8010729d,(%esp)
80103bf2:	e8 69 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103bf7:	c7 04 24 90 72 10 80 	movl   $0x80107290,(%esp)
80103bfe:	e8 5d c7 ff ff       	call   80100360 <panic>
80103c03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <yield>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c16:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c1d:	e8 6e 06 00 00       	call   80104290 <acquire>
  myproc()->state = RUNNABLE;
80103c22:	e8 c9 fa ff ff       	call   801036f0 <myproc>
80103c27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c2e:	e8 1d fe ff ff       	call   80103a50 <sched>
  release(&ptable.lock);
80103c33:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c3a:	e8 c1 06 00 00       	call   80104300 <release>
}
80103c3f:	c9                   	leave  
80103c40:	c3                   	ret    
80103c41:	eb 0d                	jmp    80103c50 <sleep>
80103c43:	90                   	nop
80103c44:	90                   	nop
80103c45:	90                   	nop
80103c46:	90                   	nop
80103c47:	90                   	nop
80103c48:	90                   	nop
80103c49:	90                   	nop
80103c4a:	90                   	nop
80103c4b:	90                   	nop
80103c4c:	90                   	nop
80103c4d:	90                   	nop
80103c4e:	90                   	nop
80103c4f:	90                   	nop

80103c50 <sleep>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
80103c59:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c5f:	e8 8c fa ff ff       	call   801036f0 <myproc>
  if(p == 0)
80103c64:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c66:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c68:	0f 84 7c 00 00 00    	je     80103cea <sleep+0x9a>
  if(lk == 0)
80103c6e:	85 f6                	test   %esi,%esi
80103c70:	74 6c                	je     80103cde <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c72:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80103c78:	74 46                	je     80103cc0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c7a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c81:	e8 0a 06 00 00       	call   80104290 <acquire>
    release(lk);
80103c86:	89 34 24             	mov    %esi,(%esp)
80103c89:	e8 72 06 00 00       	call   80104300 <release>
  p->chan = chan;
80103c8e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c91:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c98:	e8 b3 fd ff ff       	call   80103a50 <sched>
  p->chan = 0;
80103c9d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ca4:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103cab:	e8 50 06 00 00       	call   80104300 <release>
    acquire(lk);
80103cb0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103cb3:	83 c4 1c             	add    $0x1c,%esp
80103cb6:	5b                   	pop    %ebx
80103cb7:	5e                   	pop    %esi
80103cb8:	5f                   	pop    %edi
80103cb9:	5d                   	pop    %ebp
    acquire(lk);
80103cba:	e9 d1 05 00 00       	jmp    80104290 <acquire>
80103cbf:	90                   	nop
  p->chan = chan;
80103cc0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103cc3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103cca:	e8 81 fd ff ff       	call   80103a50 <sched>
  p->chan = 0;
80103ccf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103cd6:	83 c4 1c             	add    $0x1c,%esp
80103cd9:	5b                   	pop    %ebx
80103cda:	5e                   	pop    %esi
80103cdb:	5f                   	pop    %edi
80103cdc:	5d                   	pop    %ebp
80103cdd:	c3                   	ret    
    panic("sleep without lk");
80103cde:	c7 04 24 af 72 10 80 	movl   $0x801072af,(%esp)
80103ce5:	e8 76 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103cea:	c7 04 24 a9 72 10 80 	movl   $0x801072a9,(%esp)
80103cf1:	e8 6a c6 ff ff       	call   80100360 <panic>
80103cf6:	8d 76 00             	lea    0x0(%esi),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <wait>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103d08:	e8 e3 f9 ff ff       	call   801036f0 <myproc>
  acquire(&ptable.lock);
80103d0d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
  struct proc *curproc = myproc();
80103d14:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103d16:	e8 75 05 00 00       	call   80104290 <acquire>
    havekids = 0;
80103d1b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1d:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80103d22:	eb 0f                	jmp    80103d33 <wait+0x33>
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	83 c3 7c             	add    $0x7c,%ebx
80103d2b:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103d31:	74 1d                	je     80103d50 <wait+0x50>
      if(p->parent != curproc)
80103d33:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d36:	75 f0                	jne    80103d28 <wait+0x28>
      if(p->state == ZOMBIE){
80103d38:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d3c:	74 2f                	je     80103d6d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d3e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103d41:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d46:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103d4c:	75 e5                	jne    80103d33 <wait+0x33>
80103d4e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103d50:	85 c0                	test   %eax,%eax
80103d52:	74 6e                	je     80103dc2 <wait+0xc2>
80103d54:	8b 46 24             	mov    0x24(%esi),%eax
80103d57:	85 c0                	test   %eax,%eax
80103d59:	75 67                	jne    80103dc2 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d5b:	c7 44 24 04 40 2d 11 	movl   $0x80112d40,0x4(%esp)
80103d62:	80 
80103d63:	89 34 24             	mov    %esi,(%esp)
80103d66:	e8 e5 fe ff ff       	call   80103c50 <sleep>
  }
80103d6b:	eb ae                	jmp    80103d1b <wait+0x1b>
        kfree(p->kstack);
80103d6d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d70:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d73:	89 04 24             	mov    %eax,(%esp)
80103d76:	e8 75 e5 ff ff       	call   801022f0 <kfree>
        freevm(p->pgdir);
80103d7b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 13 2c 00 00       	call   801069a0 <freevm>
        release(&ptable.lock);
80103d8d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
        p->pid = 0;
80103d94:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d9b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103da2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103da6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103dad:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103db4:	e8 47 05 00 00       	call   80104300 <release>
}
80103db9:	83 c4 10             	add    $0x10,%esp
        return pid;
80103dbc:	89 f0                	mov    %esi,%eax
}
80103dbe:	5b                   	pop    %ebx
80103dbf:	5e                   	pop    %esi
80103dc0:	5d                   	pop    %ebp
80103dc1:	c3                   	ret    
      release(&ptable.lock);
80103dc2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103dc9:	e8 32 05 00 00       	call   80104300 <release>
}
80103dce:	83 c4 10             	add    $0x10,%esp
      return -1;
80103dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dd6:	5b                   	pop    %ebx
80103dd7:	5e                   	pop    %esi
80103dd8:	5d                   	pop    %ebp
80103dd9:	c3                   	ret    
80103dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103de0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 14             	sub    $0x14,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dea:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103df1:	e8 9a 04 00 00       	call   80104290 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df6:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103dfb:	eb 0d                	jmp    80103e0a <wakeup+0x2a>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
80103e00:	83 c0 7c             	add    $0x7c,%eax
80103e03:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103e08:	74 1e                	je     80103e28 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103e0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e0e:	75 f0                	jne    80103e00 <wakeup+0x20>
80103e10:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e13:	75 eb                	jne    80103e00 <wakeup+0x20>
      p->state = RUNNABLE;
80103e15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1c:	83 c0 7c             	add    $0x7c,%eax
80103e1f:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103e24:	75 e4                	jne    80103e0a <wakeup+0x2a>
80103e26:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103e28:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80103e2f:	83 c4 14             	add    $0x14,%esp
80103e32:	5b                   	pop    %ebx
80103e33:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e34:	e9 c7 04 00 00       	jmp    80104300 <release>
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 14             	sub    $0x14,%esp
80103e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e4a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e51:	e8 3a 04 00 00       	call   80104290 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e56:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103e5b:	eb 0d                	jmp    80103e6a <kill+0x2a>
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
80103e60:	83 c0 7c             	add    $0x7c,%eax
80103e63:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103e68:	74 36                	je     80103ea0 <kill+0x60>
    if(p->pid == pid){
80103e6a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e6d:	75 f1                	jne    80103e60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e6f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e73:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e7a:	74 14                	je     80103e90 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e7c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e83:	e8 78 04 00 00       	call   80104300 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e88:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e8b:	31 c0                	xor    %eax,%eax
}
80103e8d:	5b                   	pop    %ebx
80103e8e:	5d                   	pop    %ebp
80103e8f:	c3                   	ret    
        p->state = RUNNABLE;
80103e90:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e97:	eb e3                	jmp    80103e7c <kill+0x3c>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103ea0:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ea7:	e8 54 04 00 00       	call   80104300 <release>
}
80103eac:	83 c4 14             	add    $0x14,%esp
  return -1;
80103eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103eb4:	5b                   	pop    %ebx
80103eb5:	5d                   	pop    %ebp
80103eb6:	c3                   	ret    
80103eb7:	89 f6                	mov    %esi,%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
80103ecb:	83 ec 4c             	sub    $0x4c,%esp
80103ece:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ed1:	eb 20                	jmp    80103ef3 <procdump+0x33>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ed8:	c7 04 24 3b 76 10 80 	movl   $0x8010763b,(%esp)
80103edf:	e8 6c c7 ff ff       	call   80100650 <cprintf>
80103ee4:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee7:	81 fb e0 4c 11 80    	cmp    $0x80114ce0,%ebx
80103eed:	0f 84 8d 00 00 00    	je     80103f80 <procdump+0xc0>
    if(p->state == UNUSED)
80103ef3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ef6:	85 c0                	test   %eax,%eax
80103ef8:	74 ea                	je     80103ee4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103efa:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103efd:	ba c0 72 10 80       	mov    $0x801072c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f02:	77 11                	ja     80103f15 <procdump+0x55>
80103f04:	8b 14 85 20 73 10 80 	mov    -0x7fef8ce0(,%eax,4),%edx
      state = "???";
80103f0b:	b8 c0 72 10 80       	mov    $0x801072c0,%eax
80103f10:	85 d2                	test   %edx,%edx
80103f12:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f15:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f18:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f1c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f20:	c7 04 24 c4 72 10 80 	movl   $0x801072c4,(%esp)
80103f27:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f2b:	e8 20 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f30:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f34:	75 a2                	jne    80103ed8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f36:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f39:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f3d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f40:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f43:	8b 40 0c             	mov    0xc(%eax),%eax
80103f46:	83 c0 08             	add    $0x8,%eax
80103f49:	89 04 24             	mov    %eax,(%esp)
80103f4c:	e8 ef 01 00 00       	call   80104140 <getcallerpcs>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f58:	8b 17                	mov    (%edi),%edx
80103f5a:	85 d2                	test   %edx,%edx
80103f5c:	0f 84 76 ff ff ff    	je     80103ed8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f62:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f66:	83 c7 04             	add    $0x4,%edi
80103f69:	c7 04 24 01 6d 10 80 	movl   $0x80106d01,(%esp)
80103f70:	e8 db c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f75:	39 f7                	cmp    %esi,%edi
80103f77:	75 df                	jne    80103f58 <procdump+0x98>
80103f79:	e9 5a ff ff ff       	jmp    80103ed8 <procdump+0x18>
80103f7e:	66 90                	xchg   %ax,%ax
  }
}
80103f80:	83 c4 4c             	add    $0x4c,%esp
80103f83:	5b                   	pop    %ebx
80103f84:	5e                   	pop    %esi
80103f85:	5f                   	pop    %edi
80103f86:	5d                   	pop    %ebp
80103f87:	c3                   	ret    
80103f88:	90                   	nop
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f90 <sysinfo>:

// sysinfo: returns sysinfo information
int sysinfo(int n) {
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	83 ec 08             	sub    $0x8,%esp
80103f96:	8b 45 08             	mov    0x8(%ebp),%eax
  // If param == 0: the total number of active processes (ready, running, waiting, or zombie) in the system.
  // If param == 1: the total number of system calls that has made so far since the system boot up.
  // Do not include the current sysinfo syscalls attempt when returning the number.
  // If param == 2: the number of free memory pages in the system. If there is one free page left, the return value should be 1 (= 1 page).
  // Otherwise: return error (-1)
  if (n == 0) {
80103f99:	85 c0                	test   %eax,%eax
80103f9b:	75 2b                	jne    80103fc8 <sysinfo+0x38>
80103f9d:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     //count the total number of active processes (ready, running, waiting, or zombie) in the system.
     struct proc *p;
     int numActProcs = 0;
     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
       if(p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING || p->state == ZOMBIE) {
80103fa8:	8b 4a 0c             	mov    0xc(%edx),%ecx
80103fab:	83 e9 02             	sub    $0x2,%ecx
         numActProcs++;
80103fae:	83 f9 04             	cmp    $0x4,%ecx
80103fb1:	83 d0 00             	adc    $0x0,%eax
     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb4:	83 c2 7c             	add    $0x7c,%edx
80103fb7:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
80103fbd:	75 e9                	jne    80103fa8 <sysinfo+0x18>
    kCountFreePages(); // function to compute the number of free pages in the system.
    return numFreePages;
}
else {
  return -1; }
}
80103fbf:	c9                   	leave  
80103fc0:	c3                   	ret    
80103fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else if (n == 1) {
80103fc8:	83 f8 01             	cmp    $0x1,%eax
80103fcb:	74 11                	je     80103fde <sysinfo+0x4e>
  else if (n == 2) {
80103fcd:	83 f8 02             	cmp    $0x2,%eax
80103fd0:	75 13                	jne    80103fe5 <sysinfo+0x55>
    kCountFreePages(); // function to compute the number of free pages in the system.
80103fd2:	e8 29 e5 ff ff       	call   80102500 <kCountFreePages>
    return numFreePages;
80103fd7:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}
80103fdc:	c9                   	leave  
80103fdd:	c3                   	ret    
    return numSysCalls;
80103fde:	a1 74 4c 11 80       	mov    0x80114c74,%eax
}
80103fe3:	c9                   	leave  
80103fe4:	c3                   	ret    
  return -1; }
80103fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fea:	c9                   	leave  
80103feb:	c3                   	ret    
80103fec:	66 90                	xchg   %ax,%ax
80103fee:	66 90                	xchg   %ax,%ax

80103ff0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 14             	sub    $0x14,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103ffa:	c7 44 24 04 38 73 10 	movl   $0x80107338,0x4(%esp)
80104001:	80 
80104002:	8d 43 04             	lea    0x4(%ebx),%eax
80104005:	89 04 24             	mov    %eax,(%esp)
80104008:	e8 13 01 00 00       	call   80104120 <initlock>
  lk->name = name;
8010400d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104010:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104016:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010401d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104020:	83 c4 14             	add    $0x14,%esp
80104023:	5b                   	pop    %ebx
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
80104026:	8d 76 00             	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104030 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
80104035:	83 ec 10             	sub    $0x10,%esp
80104038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010403b:	8d 73 04             	lea    0x4(%ebx),%esi
8010403e:	89 34 24             	mov    %esi,(%esp)
80104041:	e8 4a 02 00 00       	call   80104290 <acquire>
  while (lk->locked) {
80104046:	8b 13                	mov    (%ebx),%edx
80104048:	85 d2                	test   %edx,%edx
8010404a:	74 16                	je     80104062 <acquiresleep+0x32>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104050:	89 74 24 04          	mov    %esi,0x4(%esp)
80104054:	89 1c 24             	mov    %ebx,(%esp)
80104057:	e8 f4 fb ff ff       	call   80103c50 <sleep>
  while (lk->locked) {
8010405c:	8b 03                	mov    (%ebx),%eax
8010405e:	85 c0                	test   %eax,%eax
80104060:	75 ee                	jne    80104050 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104062:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104068:	e8 83 f6 ff ff       	call   801036f0 <myproc>
8010406d:	8b 40 10             	mov    0x10(%eax),%eax
80104070:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104073:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104076:	83 c4 10             	add    $0x10,%esp
80104079:	5b                   	pop    %ebx
8010407a:	5e                   	pop    %esi
8010407b:	5d                   	pop    %ebp
  release(&lk->lk);
8010407c:	e9 7f 02 00 00       	jmp    80104300 <release>
80104081:	eb 0d                	jmp    80104090 <releasesleep>
80104083:	90                   	nop
80104084:	90                   	nop
80104085:	90                   	nop
80104086:	90                   	nop
80104087:	90                   	nop
80104088:	90                   	nop
80104089:	90                   	nop
8010408a:	90                   	nop
8010408b:	90                   	nop
8010408c:	90                   	nop
8010408d:	90                   	nop
8010408e:	90                   	nop
8010408f:	90                   	nop

80104090 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
80104095:	83 ec 10             	sub    $0x10,%esp
80104098:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010409b:	8d 73 04             	lea    0x4(%ebx),%esi
8010409e:	89 34 24             	mov    %esi,(%esp)
801040a1:	e8 ea 01 00 00       	call   80104290 <acquire>
  lk->locked = 0;
801040a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040ac:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801040b3:	89 1c 24             	mov    %ebx,(%esp)
801040b6:	e8 25 fd ff ff       	call   80103de0 <wakeup>
  release(&lk->lk);
801040bb:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040be:	83 c4 10             	add    $0x10,%esp
801040c1:	5b                   	pop    %ebx
801040c2:	5e                   	pop    %esi
801040c3:	5d                   	pop    %ebp
  release(&lk->lk);
801040c4:	e9 37 02 00 00       	jmp    80104300 <release>
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
801040d4:	31 ff                	xor    %edi,%edi
{
801040d6:	56                   	push   %esi
801040d7:	53                   	push   %ebx
801040d8:	83 ec 1c             	sub    $0x1c,%esp
801040db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040de:	8d 73 04             	lea    0x4(%ebx),%esi
801040e1:	89 34 24             	mov    %esi,(%esp)
801040e4:	e8 a7 01 00 00       	call   80104290 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801040e9:	8b 03                	mov    (%ebx),%eax
801040eb:	85 c0                	test   %eax,%eax
801040ed:	74 13                	je     80104102 <holdingsleep+0x32>
801040ef:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801040f2:	e8 f9 f5 ff ff       	call   801036f0 <myproc>
801040f7:	3b 58 10             	cmp    0x10(%eax),%ebx
801040fa:	0f 94 c0             	sete   %al
801040fd:	0f b6 c0             	movzbl %al,%eax
80104100:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104102:	89 34 24             	mov    %esi,(%esp)
80104105:	e8 f6 01 00 00       	call   80104300 <release>
  return r;
}
8010410a:	83 c4 1c             	add    $0x1c,%esp
8010410d:	89 f8                	mov    %edi,%eax
8010410f:	5b                   	pop    %ebx
80104110:	5e                   	pop    %esi
80104111:	5f                   	pop    %edi
80104112:	5d                   	pop    %ebp
80104113:	c3                   	ret    
80104114:	66 90                	xchg   %ax,%ax
80104116:	66 90                	xchg   %ax,%ax
80104118:	66 90                	xchg   %ax,%ax
8010411a:	66 90                	xchg   %ax,%ax
8010411c:	66 90                	xchg   %ax,%ax
8010411e:	66 90                	xchg   %ax,%ax

80104120 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104126:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010412f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104132:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104139:	5d                   	pop    %ebp
8010413a:	c3                   	ret    
8010413b:	90                   	nop
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104149:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010414a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010414d:	31 c0                	xor    %eax,%eax
8010414f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104150:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104156:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010415c:	77 1a                	ja     80104178 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010415e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104161:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104164:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104167:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104169:	83 f8 0a             	cmp    $0xa,%eax
8010416c:	75 e2                	jne    80104150 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010416e:	5b                   	pop    %ebx
8010416f:	5d                   	pop    %ebp
80104170:	c3                   	ret    
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104178:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010417f:	83 c0 01             	add    $0x1,%eax
80104182:	83 f8 0a             	cmp    $0xa,%eax
80104185:	74 e7                	je     8010416e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104187:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010418e:	83 c0 01             	add    $0x1,%eax
80104191:	83 f8 0a             	cmp    $0xa,%eax
80104194:	75 e2                	jne    80104178 <getcallerpcs+0x38>
80104196:	eb d6                	jmp    8010416e <getcallerpcs+0x2e>
80104198:	90                   	nop
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 04             	sub    $0x4,%esp
801041a7:	9c                   	pushf  
801041a8:	5b                   	pop    %ebx
  asm volatile("cli");
801041a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801041aa:	e8 a1 f4 ff ff       	call   80103650 <mycpu>
801041af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041b5:	85 c0                	test   %eax,%eax
801041b7:	75 11                	jne    801041ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801041b9:	e8 92 f4 ff ff       	call   80103650 <mycpu>
801041be:	81 e3 00 02 00 00    	and    $0x200,%ebx
801041c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801041ca:	e8 81 f4 ff ff       	call   80103650 <mycpu>
801041cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801041d6:	83 c4 04             	add    $0x4,%esp
801041d9:	5b                   	pop    %ebx
801041da:	5d                   	pop    %ebp
801041db:	c3                   	ret    
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041e0 <popcli>:

void
popcli(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e6:	9c                   	pushf  
801041e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e8:	f6 c4 02             	test   $0x2,%ah
801041eb:	75 49                	jne    80104236 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041ed:	e8 5e f4 ff ff       	call   80103650 <mycpu>
801041f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041fb:	85 d2                	test   %edx,%edx
801041fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104203:	78 25                	js     8010422a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104205:	e8 46 f4 ff ff       	call   80103650 <mycpu>
8010420a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104210:	85 d2                	test   %edx,%edx
80104212:	74 04                	je     80104218 <popcli+0x38>
    sti();
}
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104218:	e8 33 f4 ff ff       	call   80103650 <mycpu>
8010421d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	74 ed                	je     80104214 <popcli+0x34>
  asm volatile("sti");
80104227:	fb                   	sti    
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
    panic("popcli");
8010422a:	c7 04 24 5a 73 10 80 	movl   $0x8010735a,(%esp)
80104231:	e8 2a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104236:	c7 04 24 43 73 10 80 	movl   $0x80107343,(%esp)
8010423d:	e8 1e c1 ff ff       	call   80100360 <panic>
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <holding>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
80104254:	31 f6                	xor    %esi,%esi
{
80104256:	53                   	push   %ebx
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010425a:	e8 41 ff ff ff       	call   801041a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010425f:	8b 03                	mov    (%ebx),%eax
80104261:	85 c0                	test   %eax,%eax
80104263:	74 12                	je     80104277 <holding+0x27>
80104265:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104268:	e8 e3 f3 ff ff       	call   80103650 <mycpu>
8010426d:	39 c3                	cmp    %eax,%ebx
8010426f:	0f 94 c0             	sete   %al
80104272:	0f b6 c0             	movzbl %al,%eax
80104275:	89 c6                	mov    %eax,%esi
  popcli();
80104277:	e8 64 ff ff ff       	call   801041e0 <popcli>
}
8010427c:	89 f0                	mov    %esi,%eax
8010427e:	5b                   	pop    %ebx
8010427f:	5e                   	pop    %esi
80104280:	5d                   	pop    %ebp
80104281:	c3                   	ret    
80104282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <acquire>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104297:	e8 04 ff ff ff       	call   801041a0 <pushcli>
  if(holding(lk))
8010429c:	8b 45 08             	mov    0x8(%ebp),%eax
8010429f:	89 04 24             	mov    %eax,(%esp)
801042a2:	e8 a9 ff ff ff       	call   80104250 <holding>
801042a7:	85 c0                	test   %eax,%eax
801042a9:	75 3a                	jne    801042e5 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
801042ab:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
801042b0:	8b 55 08             	mov    0x8(%ebp),%edx
801042b3:	89 c8                	mov    %ecx,%eax
801042b5:	f0 87 02             	lock xchg %eax,(%edx)
801042b8:	85 c0                	test   %eax,%eax
801042ba:	75 f4                	jne    801042b0 <acquire+0x20>
  __sync_synchronize();
801042bc:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801042bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042c2:	e8 89 f3 ff ff       	call   80103650 <mycpu>
801042c7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801042ca:	8b 45 08             	mov    0x8(%ebp),%eax
801042cd:	83 c0 0c             	add    $0xc,%eax
801042d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801042d4:	8d 45 08             	lea    0x8(%ebp),%eax
801042d7:	89 04 24             	mov    %eax,(%esp)
801042da:	e8 61 fe ff ff       	call   80104140 <getcallerpcs>
}
801042df:	83 c4 14             	add    $0x14,%esp
801042e2:	5b                   	pop    %ebx
801042e3:	5d                   	pop    %ebp
801042e4:	c3                   	ret    
    panic("acquire");
801042e5:	c7 04 24 61 73 10 80 	movl   $0x80107361,(%esp)
801042ec:	e8 6f c0 ff ff       	call   80100360 <panic>
801042f1:	eb 0d                	jmp    80104300 <release>
801042f3:	90                   	nop
801042f4:	90                   	nop
801042f5:	90                   	nop
801042f6:	90                   	nop
801042f7:	90                   	nop
801042f8:	90                   	nop
801042f9:	90                   	nop
801042fa:	90                   	nop
801042fb:	90                   	nop
801042fc:	90                   	nop
801042fd:	90                   	nop
801042fe:	90                   	nop
801042ff:	90                   	nop

80104300 <release>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 14             	sub    $0x14,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010430a:	89 1c 24             	mov    %ebx,(%esp)
8010430d:	e8 3e ff ff ff       	call   80104250 <holding>
80104312:	85 c0                	test   %eax,%eax
80104314:	74 21                	je     80104337 <release+0x37>
  lk->pcs[0] = 0;
80104316:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010431d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104324:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104327:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010432d:	83 c4 14             	add    $0x14,%esp
80104330:	5b                   	pop    %ebx
80104331:	5d                   	pop    %ebp
  popcli();
80104332:	e9 a9 fe ff ff       	jmp    801041e0 <popcli>
    panic("release");
80104337:	c7 04 24 69 73 10 80 	movl   $0x80107369,(%esp)
8010433e:	e8 1d c0 ff ff       	call   80100360 <panic>
80104343:	66 90                	xchg   %ax,%ax
80104345:	66 90                	xchg   %ax,%ax
80104347:	66 90                	xchg   %ax,%ax
80104349:	66 90                	xchg   %ax,%ax
8010434b:	66 90                	xchg   %ax,%ax
8010434d:	66 90                	xchg   %ax,%ax
8010434f:	90                   	nop

80104350 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	8b 55 08             	mov    0x8(%ebp),%edx
80104356:	57                   	push   %edi
80104357:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010435a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010435b:	f6 c2 03             	test   $0x3,%dl
8010435e:	75 05                	jne    80104365 <memset+0x15>
80104360:	f6 c1 03             	test   $0x3,%cl
80104363:	74 13                	je     80104378 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104365:	89 d7                	mov    %edx,%edi
80104367:	8b 45 0c             	mov    0xc(%ebp),%eax
8010436a:	fc                   	cld    
8010436b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010436d:	5b                   	pop    %ebx
8010436e:	89 d0                	mov    %edx,%eax
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	90                   	nop
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104378:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010437c:	c1 e9 02             	shr    $0x2,%ecx
8010437f:	89 f8                	mov    %edi,%eax
80104381:	89 fb                	mov    %edi,%ebx
80104383:	c1 e0 18             	shl    $0x18,%eax
80104386:	c1 e3 10             	shl    $0x10,%ebx
80104389:	09 d8                	or     %ebx,%eax
8010438b:	09 f8                	or     %edi,%eax
8010438d:	c1 e7 08             	shl    $0x8,%edi
80104390:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104392:	89 d7                	mov    %edx,%edi
80104394:	fc                   	cld    
80104395:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104397:	5b                   	pop    %ebx
80104398:	89 d0                	mov    %edx,%eax
8010439a:	5f                   	pop    %edi
8010439b:	5d                   	pop    %ebp
8010439c:	c3                   	ret    
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	8b 45 10             	mov    0x10(%ebp),%eax
801043a6:	57                   	push   %edi
801043a7:	56                   	push   %esi
801043a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043ab:	53                   	push   %ebx
801043ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043af:	85 c0                	test   %eax,%eax
801043b1:	8d 78 ff             	lea    -0x1(%eax),%edi
801043b4:	74 26                	je     801043dc <memcmp+0x3c>
    if(*s1 != *s2)
801043b6:	0f b6 03             	movzbl (%ebx),%eax
801043b9:	31 d2                	xor    %edx,%edx
801043bb:	0f b6 0e             	movzbl (%esi),%ecx
801043be:	38 c8                	cmp    %cl,%al
801043c0:	74 16                	je     801043d8 <memcmp+0x38>
801043c2:	eb 24                	jmp    801043e8 <memcmp+0x48>
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801043cd:	83 c2 01             	add    $0x1,%edx
801043d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043d4:	38 c8                	cmp    %cl,%al
801043d6:	75 10                	jne    801043e8 <memcmp+0x48>
  while(n-- > 0){
801043d8:	39 fa                	cmp    %edi,%edx
801043da:	75 ec                	jne    801043c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801043dc:	5b                   	pop    %ebx
  return 0;
801043dd:	31 c0                	xor    %eax,%eax
}
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
801043e3:	90                   	nop
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e8:	5b                   	pop    %ebx
      return *s1 - *s2;
801043e9:	29 c8                	sub    %ecx,%eax
}
801043eb:	5e                   	pop    %esi
801043ec:	5f                   	pop    %edi
801043ed:	5d                   	pop    %ebp
801043ee:	c3                   	ret    
801043ef:	90                   	nop

801043f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	8b 45 08             	mov    0x8(%ebp),%eax
801043f7:	56                   	push   %esi
801043f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043fb:	53                   	push   %ebx
801043fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043ff:	39 c6                	cmp    %eax,%esi
80104401:	73 35                	jae    80104438 <memmove+0x48>
80104403:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104406:	39 c8                	cmp    %ecx,%eax
80104408:	73 2e                	jae    80104438 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010440a:	85 db                	test   %ebx,%ebx
    d += n;
8010440c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010440f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104412:	74 1b                	je     8010442f <memmove+0x3f>
80104414:	f7 db                	neg    %ebx
80104416:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104419:	01 fb                	add    %edi,%ebx
8010441b:	90                   	nop
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104420:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104424:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104427:	83 ea 01             	sub    $0x1,%edx
8010442a:	83 fa ff             	cmp    $0xffffffff,%edx
8010442d:	75 f1                	jne    80104420 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010442f:	5b                   	pop    %ebx
80104430:	5e                   	pop    %esi
80104431:	5f                   	pop    %edi
80104432:	5d                   	pop    %ebp
80104433:	c3                   	ret    
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104438:	31 d2                	xor    %edx,%edx
8010443a:	85 db                	test   %ebx,%ebx
8010443c:	74 f1                	je     8010442f <memmove+0x3f>
8010443e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104440:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104444:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104447:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010444a:	39 da                	cmp    %ebx,%edx
8010444c:	75 f2                	jne    80104440 <memmove+0x50>
}
8010444e:	5b                   	pop    %ebx
8010444f:	5e                   	pop    %esi
80104450:	5f                   	pop    %edi
80104451:	5d                   	pop    %ebp
80104452:	c3                   	ret    
80104453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104463:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104464:	eb 8a                	jmp    801043f0 <memmove>
80104466:	8d 76 00             	lea    0x0(%esi),%esi
80104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104470 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	8b 75 10             	mov    0x10(%ebp),%esi
80104477:	53                   	push   %ebx
80104478:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010447b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010447e:	85 f6                	test   %esi,%esi
80104480:	74 30                	je     801044b2 <strncmp+0x42>
80104482:	0f b6 01             	movzbl (%ecx),%eax
80104485:	84 c0                	test   %al,%al
80104487:	74 2f                	je     801044b8 <strncmp+0x48>
80104489:	0f b6 13             	movzbl (%ebx),%edx
8010448c:	38 d0                	cmp    %dl,%al
8010448e:	75 46                	jne    801044d6 <strncmp+0x66>
80104490:	8d 51 01             	lea    0x1(%ecx),%edx
80104493:	01 ce                	add    %ecx,%esi
80104495:	eb 14                	jmp    801044ab <strncmp+0x3b>
80104497:	90                   	nop
80104498:	0f b6 02             	movzbl (%edx),%eax
8010449b:	84 c0                	test   %al,%al
8010449d:	74 31                	je     801044d0 <strncmp+0x60>
8010449f:	0f b6 19             	movzbl (%ecx),%ebx
801044a2:	83 c2 01             	add    $0x1,%edx
801044a5:	38 d8                	cmp    %bl,%al
801044a7:	75 17                	jne    801044c0 <strncmp+0x50>
    n--, p++, q++;
801044a9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801044ab:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801044ad:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801044b0:	75 e6                	jne    80104498 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801044b2:	5b                   	pop    %ebx
    return 0;
801044b3:	31 c0                	xor    %eax,%eax
}
801044b5:	5e                   	pop    %esi
801044b6:	5d                   	pop    %ebp
801044b7:	c3                   	ret    
801044b8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801044bb:	31 c0                	xor    %eax,%eax
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
801044c0:	0f b6 d3             	movzbl %bl,%edx
801044c3:	29 d0                	sub    %edx,%eax
}
801044c5:	5b                   	pop    %ebx
801044c6:	5e                   	pop    %esi
801044c7:	5d                   	pop    %ebp
801044c8:	c3                   	ret    
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801044d4:	eb ea                	jmp    801044c0 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801044d6:	89 d3                	mov    %edx,%ebx
801044d8:	eb e6                	jmp    801044c0 <strncmp+0x50>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
801044e6:	56                   	push   %esi
801044e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044ea:	53                   	push   %ebx
801044eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801044ee:	89 c2                	mov    %eax,%edx
801044f0:	eb 19                	jmp    8010450b <strncpy+0x2b>
801044f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044f8:	83 c3 01             	add    $0x1,%ebx
801044fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801044ff:	83 c2 01             	add    $0x1,%edx
80104502:	84 c9                	test   %cl,%cl
80104504:	88 4a ff             	mov    %cl,-0x1(%edx)
80104507:	74 09                	je     80104512 <strncpy+0x32>
80104509:	89 f1                	mov    %esi,%ecx
8010450b:	85 c9                	test   %ecx,%ecx
8010450d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104510:	7f e6                	jg     801044f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104512:	31 c9                	xor    %ecx,%ecx
80104514:	85 f6                	test   %esi,%esi
80104516:	7e 0f                	jle    80104527 <strncpy+0x47>
    *s++ = 0;
80104518:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010451c:	89 f3                	mov    %esi,%ebx
8010451e:	83 c1 01             	add    $0x1,%ecx
80104521:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104523:	85 db                	test   %ebx,%ebx
80104525:	7f f1                	jg     80104518 <strncpy+0x38>
  return os;
}
80104527:	5b                   	pop    %ebx
80104528:	5e                   	pop    %esi
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret    
8010452b:	90                   	nop
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104536:	56                   	push   %esi
80104537:	8b 45 08             	mov    0x8(%ebp),%eax
8010453a:	53                   	push   %ebx
8010453b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010453e:	85 c9                	test   %ecx,%ecx
80104540:	7e 26                	jle    80104568 <safestrcpy+0x38>
80104542:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104546:	89 c1                	mov    %eax,%ecx
80104548:	eb 17                	jmp    80104561 <safestrcpy+0x31>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104550:	83 c2 01             	add    $0x1,%edx
80104553:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104557:	83 c1 01             	add    $0x1,%ecx
8010455a:	84 db                	test   %bl,%bl
8010455c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010455f:	74 04                	je     80104565 <safestrcpy+0x35>
80104561:	39 f2                	cmp    %esi,%edx
80104563:	75 eb                	jne    80104550 <safestrcpy+0x20>
    ;
  *s = 0;
80104565:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104568:	5b                   	pop    %ebx
80104569:	5e                   	pop    %esi
8010456a:	5d                   	pop    %ebp
8010456b:	c3                   	ret    
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <strlen>:

int
strlen(const char *s)
{
80104570:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104571:	31 c0                	xor    %eax,%eax
{
80104573:	89 e5                	mov    %esp,%ebp
80104575:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104578:	80 3a 00             	cmpb   $0x0,(%edx)
8010457b:	74 0c                	je     80104589 <strlen+0x19>
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
80104580:	83 c0 01             	add    $0x1,%eax
80104583:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104587:	75 f7                	jne    80104580 <strlen+0x10>
    ;
  return n;
}
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    

8010458b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010458b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010458f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104593:	55                   	push   %ebp
  pushl %ebx
80104594:	53                   	push   %ebx
  pushl %esi
80104595:	56                   	push   %esi
  pushl %edi
80104596:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104597:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104599:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010459b:	5f                   	pop    %edi
  popl %esi
8010459c:	5e                   	pop    %esi
  popl %ebx
8010459d:	5b                   	pop    %ebx
  popl %ebp
8010459e:	5d                   	pop    %ebp
  ret
8010459f:	c3                   	ret    

801045a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801045aa:	e8 41 f1 ff ff       	call   801036f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045af:	8b 00                	mov    (%eax),%eax
801045b1:	39 d8                	cmp    %ebx,%eax
801045b3:	76 1b                	jbe    801045d0 <fetchint+0x30>
801045b5:	8d 53 04             	lea    0x4(%ebx),%edx
801045b8:	39 d0                	cmp    %edx,%eax
801045ba:	72 14                	jb     801045d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801045bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801045bf:	8b 13                	mov    (%ebx),%edx
801045c1:	89 10                	mov    %edx,(%eax)
  return 0;
801045c3:	31 c0                	xor    %eax,%eax
}
801045c5:	83 c4 04             	add    $0x4,%esp
801045c8:	5b                   	pop    %ebx
801045c9:	5d                   	pop    %ebp
801045ca:	c3                   	ret    
801045cb:	90                   	nop
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801045d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d5:	eb ee                	jmp    801045c5 <fetchint+0x25>
801045d7:	89 f6                	mov    %esi,%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 04             	sub    $0x4,%esp
801045e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801045ea:	e8 01 f1 ff ff       	call   801036f0 <myproc>

  if(addr >= curproc->sz)
801045ef:	39 18                	cmp    %ebx,(%eax)
801045f1:	76 26                	jbe    80104619 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
801045f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045f6:	89 da                	mov    %ebx,%edx
801045f8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801045fa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801045fc:	39 c3                	cmp    %eax,%ebx
801045fe:	73 19                	jae    80104619 <fetchstr+0x39>
    if(*s == 0)
80104600:	80 3b 00             	cmpb   $0x0,(%ebx)
80104603:	75 0d                	jne    80104612 <fetchstr+0x32>
80104605:	eb 21                	jmp    80104628 <fetchstr+0x48>
80104607:	90                   	nop
80104608:	80 3a 00             	cmpb   $0x0,(%edx)
8010460b:	90                   	nop
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104610:	74 16                	je     80104628 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104612:	83 c2 01             	add    $0x1,%edx
80104615:	39 d0                	cmp    %edx,%eax
80104617:	77 ef                	ja     80104608 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104619:	83 c4 04             	add    $0x4,%esp
    return -1;
8010461c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104621:	5b                   	pop    %ebx
80104622:	5d                   	pop    %ebp
80104623:	c3                   	ret    
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104628:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010462b:	89 d0                	mov    %edx,%eax
8010462d:	29 d8                	sub    %ebx,%eax
}
8010462f:	5b                   	pop    %ebx
80104630:	5d                   	pop    %ebp
80104631:	c3                   	ret    
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	8b 75 0c             	mov    0xc(%ebp),%esi
80104647:	53                   	push   %ebx
80104648:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010464b:	e8 a0 f0 ff ff       	call   801036f0 <myproc>
80104650:	89 75 0c             	mov    %esi,0xc(%ebp)
80104653:	8b 40 18             	mov    0x18(%eax),%eax
80104656:	8b 40 44             	mov    0x44(%eax),%eax
80104659:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010465d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104660:	5b                   	pop    %ebx
80104661:	5e                   	pop    %esi
80104662:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104663:	e9 38 ff ff ff       	jmp    801045a0 <fetchint>
80104668:	90                   	nop
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	83 ec 20             	sub    $0x20,%esp
80104678:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010467b:	e8 70 f0 ff ff       	call   801036f0 <myproc>
80104680:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104682:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104685:	89 44 24 04          	mov    %eax,0x4(%esp)
80104689:	8b 45 08             	mov    0x8(%ebp),%eax
8010468c:	89 04 24             	mov    %eax,(%esp)
8010468f:	e8 ac ff ff ff       	call   80104640 <argint>
80104694:	85 c0                	test   %eax,%eax
80104696:	78 28                	js     801046c0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104698:	85 db                	test   %ebx,%ebx
8010469a:	78 24                	js     801046c0 <argptr+0x50>
8010469c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010469f:	8b 06                	mov    (%esi),%eax
801046a1:	39 c2                	cmp    %eax,%edx
801046a3:	73 1b                	jae    801046c0 <argptr+0x50>
801046a5:	01 d3                	add    %edx,%ebx
801046a7:	39 d8                	cmp    %ebx,%eax
801046a9:	72 15                	jb     801046c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801046ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801046ae:	89 10                	mov    %edx,(%eax)
  return 0;
}
801046b0:	83 c4 20             	add    $0x20,%esp
  return 0;
801046b3:	31 c0                	xor    %eax,%eax
}
801046b5:	5b                   	pop    %ebx
801046b6:	5e                   	pop    %esi
801046b7:	5d                   	pop    %ebp
801046b8:	c3                   	ret    
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c0:	83 c4 20             	add    $0x20,%esp
    return -1;
801046c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046c8:	5b                   	pop    %ebx
801046c9:	5e                   	pop    %esi
801046ca:	5d                   	pop    %ebp
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801046d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801046dd:	8b 45 08             	mov    0x8(%ebp),%eax
801046e0:	89 04 24             	mov    %eax,(%esp)
801046e3:	e8 58 ff ff ff       	call   80104640 <argint>
801046e8:	85 c0                	test   %eax,%eax
801046ea:	78 14                	js     80104700 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801046ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801046ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801046f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f6:	89 04 24             	mov    %eax,(%esp)
801046f9:	e8 e2 fe ff ff       	call   801045e0 <fetchstr>
}
801046fe:	c9                   	leave  
801046ff:	c3                   	ret    
    return -1;
80104700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104705:	c9                   	leave  
80104706:	c3                   	ret    
80104707:	89 f6                	mov    %esi,%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <syscall>:
};

uint numSysCalls; // declaration of external variable numSysCalls

void syscall(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104718:	e8 d3 ef ff ff       	call   801036f0 <myproc>

  num = curproc->tf->eax;
8010471d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104720:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104722:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104725:	8d 50 ff             	lea    -0x1(%eax),%edx
80104728:	83 fa 15             	cmp    $0x15,%edx
8010472b:	77 23                	ja     80104750 <syscall+0x40>
8010472d:	8b 14 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%edx
80104734:	85 d2                	test   %edx,%edx
80104736:	74 18                	je     80104750 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104738:	ff d2                	call   *%edx
    numSysCalls++;
8010473a:	83 05 74 4c 11 80 01 	addl   $0x1,0x80114c74
    curproc->tf->eax = syscalls[num]();
80104741:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104744:	83 c4 10             	add    $0x10,%esp
80104747:	5b                   	pop    %ebx
80104748:	5e                   	pop    %esi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104750:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104754:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104757:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
8010475b:	8b 43 10             	mov    0x10(%ebx),%eax
8010475e:	c7 04 24 71 73 10 80 	movl   $0x80107371,(%esp)
80104765:	89 44 24 04          	mov    %eax,0x4(%esp)
80104769:	e8 e2 be ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
8010476e:	8b 43 18             	mov    0x18(%ebx),%eax
80104771:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104778:	83 c4 10             	add    $0x10,%esp
8010477b:	5b                   	pop    %ebx
8010477c:	5e                   	pop    %esi
8010477d:	5d                   	pop    %ebp
8010477e:	c3                   	ret    
8010477f:	90                   	nop

80104780 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	89 c3                	mov    %eax,%ebx
80104786:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104789:	e8 62 ef ff ff       	call   801036f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010478e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104790:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104794:	85 c9                	test   %ecx,%ecx
80104796:	74 18                	je     801047b0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104798:	83 c2 01             	add    $0x1,%edx
8010479b:	83 fa 10             	cmp    $0x10,%edx
8010479e:	75 f0                	jne    80104790 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801047a0:	83 c4 04             	add    $0x4,%esp
  return -1;
801047a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047a8:	5b                   	pop    %ebx
801047a9:	5d                   	pop    %ebp
801047aa:	c3                   	ret    
801047ab:	90                   	nop
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801047b0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801047b4:	83 c4 04             	add    $0x4,%esp
      return fd;
801047b7:	89 d0                	mov    %edx,%eax
}
801047b9:	5b                   	pop    %ebx
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	53                   	push   %ebx
801047c6:	83 ec 3c             	sub    $0x3c,%esp
801047c9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801047cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047cf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801047d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047d6:	89 04 24             	mov    %eax,(%esp)
{
801047d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801047dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801047df:	e8 3c d7 ff ff       	call   80101f20 <nameiparent>
801047e4:	85 c0                	test   %eax,%eax
801047e6:	89 c7                	mov    %eax,%edi
801047e8:	0f 84 da 00 00 00    	je     801048c8 <create+0x108>
    return 0;
  ilock(dp);
801047ee:	89 04 24             	mov    %eax,(%esp)
801047f1:	e8 ba ce ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801047f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801047fd:	00 
801047fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104802:	89 3c 24             	mov    %edi,(%esp)
80104805:	e8 b6 d3 ff ff       	call   80101bc0 <dirlookup>
8010480a:	85 c0                	test   %eax,%eax
8010480c:	89 c6                	mov    %eax,%esi
8010480e:	74 40                	je     80104850 <create+0x90>
    iunlockput(dp);
80104810:	89 3c 24             	mov    %edi,(%esp)
80104813:	e8 f8 d0 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104818:	89 34 24             	mov    %esi,(%esp)
8010481b:	e8 90 ce ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104820:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104825:	75 11                	jne    80104838 <create+0x78>
80104827:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010482c:	89 f0                	mov    %esi,%eax
8010482e:	75 08                	jne    80104838 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104830:	83 c4 3c             	add    $0x3c,%esp
80104833:	5b                   	pop    %ebx
80104834:	5e                   	pop    %esi
80104835:	5f                   	pop    %edi
80104836:	5d                   	pop    %ebp
80104837:	c3                   	ret    
    iunlockput(ip);
80104838:	89 34 24             	mov    %esi,(%esp)
8010483b:	e8 d0 d0 ff ff       	call   80101910 <iunlockput>
}
80104840:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104843:	31 c0                	xor    %eax,%eax
}
80104845:	5b                   	pop    %ebx
80104846:	5e                   	pop    %esi
80104847:	5f                   	pop    %edi
80104848:	5d                   	pop    %ebp
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104850:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104854:	89 44 24 04          	mov    %eax,0x4(%esp)
80104858:	8b 07                	mov    (%edi),%eax
8010485a:	89 04 24             	mov    %eax,(%esp)
8010485d:	e8 be cc ff ff       	call   80101520 <ialloc>
80104862:	85 c0                	test   %eax,%eax
80104864:	89 c6                	mov    %eax,%esi
80104866:	0f 84 bf 00 00 00    	je     8010492b <create+0x16b>
  ilock(ip);
8010486c:	89 04 24             	mov    %eax,(%esp)
8010486f:	e8 3c ce ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104874:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104878:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010487c:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104880:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104884:	b8 01 00 00 00       	mov    $0x1,%eax
80104889:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010488d:	89 34 24             	mov    %esi,(%esp)
80104890:	e8 5b cd ff ff       	call   801015f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104895:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010489a:	74 34                	je     801048d0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010489c:	8b 46 04             	mov    0x4(%esi),%eax
8010489f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048a3:	89 3c 24             	mov    %edi,(%esp)
801048a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048aa:	e8 71 d5 ff ff       	call   80101e20 <dirlink>
801048af:	85 c0                	test   %eax,%eax
801048b1:	78 6c                	js     8010491f <create+0x15f>
  iunlockput(dp);
801048b3:	89 3c 24             	mov    %edi,(%esp)
801048b6:	e8 55 d0 ff ff       	call   80101910 <iunlockput>
}
801048bb:	83 c4 3c             	add    $0x3c,%esp
  return ip;
801048be:	89 f0                	mov    %esi,%eax
}
801048c0:	5b                   	pop    %ebx
801048c1:	5e                   	pop    %esi
801048c2:	5f                   	pop    %edi
801048c3:	5d                   	pop    %ebp
801048c4:	c3                   	ret    
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801048c8:	31 c0                	xor    %eax,%eax
801048ca:	e9 61 ff ff ff       	jmp    80104830 <create+0x70>
801048cf:	90                   	nop
    dp->nlink++;  // for ".."
801048d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801048d5:	89 3c 24             	mov    %edi,(%esp)
801048d8:	e8 13 cd ff ff       	call   801015f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801048dd:	8b 46 04             	mov    0x4(%esi),%eax
801048e0:	c7 44 24 04 18 74 10 	movl   $0x80107418,0x4(%esp)
801048e7:	80 
801048e8:	89 34 24             	mov    %esi,(%esp)
801048eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801048ef:	e8 2c d5 ff ff       	call   80101e20 <dirlink>
801048f4:	85 c0                	test   %eax,%eax
801048f6:	78 1b                	js     80104913 <create+0x153>
801048f8:	8b 47 04             	mov    0x4(%edi),%eax
801048fb:	c7 44 24 04 17 74 10 	movl   $0x80107417,0x4(%esp)
80104902:	80 
80104903:	89 34 24             	mov    %esi,(%esp)
80104906:	89 44 24 08          	mov    %eax,0x8(%esp)
8010490a:	e8 11 d5 ff ff       	call   80101e20 <dirlink>
8010490f:	85 c0                	test   %eax,%eax
80104911:	79 89                	jns    8010489c <create+0xdc>
      panic("create dots");
80104913:	c7 04 24 0b 74 10 80 	movl   $0x8010740b,(%esp)
8010491a:	e8 41 ba ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010491f:	c7 04 24 1a 74 10 80 	movl   $0x8010741a,(%esp)
80104926:	e8 35 ba ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010492b:	c7 04 24 fc 73 10 80 	movl   $0x801073fc,(%esp)
80104932:	e8 29 ba ff ff       	call   80100360 <panic>
80104937:	89 f6                	mov    %esi,%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	89 c6                	mov    %eax,%esi
80104946:	53                   	push   %ebx
80104947:	89 d3                	mov    %edx,%ebx
80104949:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010494c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010494f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104953:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010495a:	e8 e1 fc ff ff       	call   80104640 <argint>
8010495f:	85 c0                	test   %eax,%eax
80104961:	78 2d                	js     80104990 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104963:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104967:	77 27                	ja     80104990 <argfd.constprop.0+0x50>
80104969:	e8 82 ed ff ff       	call   801036f0 <myproc>
8010496e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104971:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104975:	85 c0                	test   %eax,%eax
80104977:	74 17                	je     80104990 <argfd.constprop.0+0x50>
  if(pfd)
80104979:	85 f6                	test   %esi,%esi
8010497b:	74 02                	je     8010497f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010497d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010497f:	85 db                	test   %ebx,%ebx
80104981:	74 1d                	je     801049a0 <argfd.constprop.0+0x60>
    *pf = f;
80104983:	89 03                	mov    %eax,(%ebx)
  return 0;
80104985:	31 c0                	xor    %eax,%eax
}
80104987:	83 c4 20             	add    $0x20,%esp
8010498a:	5b                   	pop    %ebx
8010498b:	5e                   	pop    %esi
8010498c:	5d                   	pop    %ebp
8010498d:	c3                   	ret    
8010498e:	66 90                	xchg   %ax,%ax
80104990:	83 c4 20             	add    $0x20,%esp
    return -1;
80104993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104998:	5b                   	pop    %ebx
80104999:	5e                   	pop    %esi
8010499a:	5d                   	pop    %ebp
8010499b:	c3                   	ret    
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801049a0:	31 c0                	xor    %eax,%eax
801049a2:	eb e3                	jmp    80104987 <argfd.constprop.0+0x47>
801049a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049b0 <sys_dup>:
{
801049b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801049b1:	31 c0                	xor    %eax,%eax
{
801049b3:	89 e5                	mov    %esp,%ebp
801049b5:	53                   	push   %ebx
801049b6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
801049b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049bc:	e8 7f ff ff ff       	call   80104940 <argfd.constprop.0>
801049c1:	85 c0                	test   %eax,%eax
801049c3:	78 23                	js     801049e8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c8:	e8 b3 fd ff ff       	call   80104780 <fdalloc>
801049cd:	85 c0                	test   %eax,%eax
801049cf:	89 c3                	mov    %eax,%ebx
801049d1:	78 15                	js     801049e8 <sys_dup+0x38>
  filedup(f);
801049d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d6:	89 04 24             	mov    %eax,(%esp)
801049d9:	e8 02 c4 ff ff       	call   80100de0 <filedup>
  return fd;
801049de:	89 d8                	mov    %ebx,%eax
}
801049e0:	83 c4 24             	add    $0x24,%esp
801049e3:	5b                   	pop    %ebx
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret    
801049e6:	66 90                	xchg   %ax,%ax
    return -1;
801049e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ed:	eb f1                	jmp    801049e0 <sys_dup+0x30>
801049ef:	90                   	nop

801049f0 <sys_read>:
{
801049f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049f1:	31 c0                	xor    %eax,%eax
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049fb:	e8 40 ff ff ff       	call   80104940 <argfd.constprop.0>
80104a00:	85 c0                	test   %eax,%eax
80104a02:	78 54                	js     80104a58 <sys_read+0x68>
80104a04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a0b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a12:	e8 29 fc ff ff       	call   80104640 <argint>
80104a17:	85 c0                	test   %eax,%eax
80104a19:	78 3d                	js     80104a58 <sys_read+0x68>
80104a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a25:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a30:	e8 3b fc ff ff       	call   80104670 <argptr>
80104a35:	85 c0                	test   %eax,%eax
80104a37:	78 1f                	js     80104a58 <sys_read+0x68>
  return fileread(f, p, n);
80104a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a4a:	89 04 24             	mov    %eax,(%esp)
80104a4d:	e8 ee c4 ff ff       	call   80100f40 <fileread>
}
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a5d:	c9                   	leave  
80104a5e:	c3                   	ret    
80104a5f:	90                   	nop

80104a60 <sys_write>:
{
80104a60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a61:	31 c0                	xor    %eax,%eax
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a6b:	e8 d0 fe ff ff       	call   80104940 <argfd.constprop.0>
80104a70:	85 c0                	test   %eax,%eax
80104a72:	78 54                	js     80104ac8 <sys_write+0x68>
80104a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a82:	e8 b9 fb ff ff       	call   80104640 <argint>
80104a87:	85 c0                	test   %eax,%eax
80104a89:	78 3d                	js     80104ac8 <sys_write+0x68>
80104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa0:	e8 cb fb ff ff       	call   80104670 <argptr>
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	78 1f                	js     80104ac8 <sys_write+0x68>
  return filewrite(f, p, n);
80104aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aba:	89 04 24             	mov    %eax,(%esp)
80104abd:	e8 1e c5 ff ff       	call   80100fe0 <filewrite>
}
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
80104acf:	90                   	nop

80104ad0 <sys_close>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104ad6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ad9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104adc:	e8 5f fe ff ff       	call   80104940 <argfd.constprop.0>
80104ae1:	85 c0                	test   %eax,%eax
80104ae3:	78 23                	js     80104b08 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104ae5:	e8 06 ec ff ff       	call   801036f0 <myproc>
80104aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104aed:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104af4:	00 
  fileclose(f);
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	89 04 24             	mov    %eax,(%esp)
80104afb:	e8 30 c3 ff ff       	call   80100e30 <fileclose>
  return 0;
80104b00:	31 c0                	xor    %eax,%eax
}
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b0d:	c9                   	leave  
80104b0e:	c3                   	ret    
80104b0f:	90                   	nop

80104b10 <sys_fstat>:
{
80104b10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b11:	31 c0                	xor    %eax,%eax
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b1b:	e8 20 fe ff ff       	call   80104940 <argfd.constprop.0>
80104b20:	85 c0                	test   %eax,%eax
80104b22:	78 34                	js     80104b58 <sys_fstat+0x48>
80104b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b27:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b2e:	00 
80104b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b3a:	e8 31 fb ff ff       	call   80104670 <argptr>
80104b3f:	85 c0                	test   %eax,%eax
80104b41:	78 15                	js     80104b58 <sys_fstat+0x48>
  return filestat(f, st);
80104b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b4d:	89 04 24             	mov    %eax,(%esp)
80104b50:	e8 9b c3 ff ff       	call   80100ef0 <filestat>
}
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    
80104b57:	90                   	nop
    return -1;
80104b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b5d:	c9                   	leave  
80104b5e:	c3                   	ret    
80104b5f:	90                   	nop

80104b60 <sys_link>:
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	53                   	push   %ebx
80104b66:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b69:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b77:	e8 54 fb ff ff       	call   801046d0 <argstr>
80104b7c:	85 c0                	test   %eax,%eax
80104b7e:	0f 88 e6 00 00 00    	js     80104c6a <sys_link+0x10a>
80104b84:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104b87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b92:	e8 39 fb ff ff       	call   801046d0 <argstr>
80104b97:	85 c0                	test   %eax,%eax
80104b99:	0f 88 cb 00 00 00    	js     80104c6a <sys_link+0x10a>
  begin_op();
80104b9f:	e8 bc df ff ff       	call   80102b60 <begin_op>
  if((ip = namei(old)) == 0){
80104ba4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ba7:	89 04 24             	mov    %eax,(%esp)
80104baa:	e8 51 d3 ff ff       	call   80101f00 <namei>
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	89 c3                	mov    %eax,%ebx
80104bb3:	0f 84 ac 00 00 00    	je     80104c65 <sys_link+0x105>
  ilock(ip);
80104bb9:	89 04 24             	mov    %eax,(%esp)
80104bbc:	e8 ef ca ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104bc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104bc6:	0f 84 91 00 00 00    	je     80104c5d <sys_link+0xfd>
  ip->nlink++;
80104bcc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104bd1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104bd4:	89 1c 24             	mov    %ebx,(%esp)
80104bd7:	e8 14 ca ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104bdc:	89 1c 24             	mov    %ebx,(%esp)
80104bdf:	e8 ac cb ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104be4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104be7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104beb:	89 04 24             	mov    %eax,(%esp)
80104bee:	e8 2d d3 ff ff       	call   80101f20 <nameiparent>
80104bf3:	85 c0                	test   %eax,%eax
80104bf5:	89 c6                	mov    %eax,%esi
80104bf7:	74 4f                	je     80104c48 <sys_link+0xe8>
  ilock(dp);
80104bf9:	89 04 24             	mov    %eax,(%esp)
80104bfc:	e8 af ca ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c01:	8b 03                	mov    (%ebx),%eax
80104c03:	39 06                	cmp    %eax,(%esi)
80104c05:	75 39                	jne    80104c40 <sys_link+0xe0>
80104c07:	8b 43 04             	mov    0x4(%ebx),%eax
80104c0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c0e:	89 34 24             	mov    %esi,(%esp)
80104c11:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c15:	e8 06 d2 ff ff       	call   80101e20 <dirlink>
80104c1a:	85 c0                	test   %eax,%eax
80104c1c:	78 22                	js     80104c40 <sys_link+0xe0>
  iunlockput(dp);
80104c1e:	89 34 24             	mov    %esi,(%esp)
80104c21:	e8 ea cc ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104c26:	89 1c 24             	mov    %ebx,(%esp)
80104c29:	e8 a2 cb ff ff       	call   801017d0 <iput>
  end_op();
80104c2e:	e8 9d df ff ff       	call   80102bd0 <end_op>
}
80104c33:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104c36:	31 c0                	xor    %eax,%eax
}
80104c38:	5b                   	pop    %ebx
80104c39:	5e                   	pop    %esi
80104c3a:	5f                   	pop    %edi
80104c3b:	5d                   	pop    %ebp
80104c3c:	c3                   	ret    
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104c40:	89 34 24             	mov    %esi,(%esp)
80104c43:	e8 c8 cc ff ff       	call   80101910 <iunlockput>
  ilock(ip);
80104c48:	89 1c 24             	mov    %ebx,(%esp)
80104c4b:	e8 60 ca ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104c50:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c55:	89 1c 24             	mov    %ebx,(%esp)
80104c58:	e8 93 c9 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104c5d:	89 1c 24             	mov    %ebx,(%esp)
80104c60:	e8 ab cc ff ff       	call   80101910 <iunlockput>
  end_op();
80104c65:	e8 66 df ff ff       	call   80102bd0 <end_op>
}
80104c6a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c72:	5b                   	pop    %ebx
80104c73:	5e                   	pop    %esi
80104c74:	5f                   	pop    %edi
80104c75:	5d                   	pop    %ebp
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_unlink>:
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	53                   	push   %ebx
80104c86:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104c89:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c97:	e8 34 fa ff ff       	call   801046d0 <argstr>
80104c9c:	85 c0                	test   %eax,%eax
80104c9e:	0f 88 76 01 00 00    	js     80104e1a <sys_unlink+0x19a>
  begin_op();
80104ca4:	e8 b7 de ff ff       	call   80102b60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ca9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104cac:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104caf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104cb3:	89 04 24             	mov    %eax,(%esp)
80104cb6:	e8 65 d2 ff ff       	call   80101f20 <nameiparent>
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104cc0:	0f 84 4f 01 00 00    	je     80104e15 <sys_unlink+0x195>
  ilock(dp);
80104cc6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104cc9:	89 34 24             	mov    %esi,(%esp)
80104ccc:	e8 df c9 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104cd1:	c7 44 24 04 18 74 10 	movl   $0x80107418,0x4(%esp)
80104cd8:	80 
80104cd9:	89 1c 24             	mov    %ebx,(%esp)
80104cdc:	e8 af ce ff ff       	call   80101b90 <namecmp>
80104ce1:	85 c0                	test   %eax,%eax
80104ce3:	0f 84 21 01 00 00    	je     80104e0a <sys_unlink+0x18a>
80104ce9:	c7 44 24 04 17 74 10 	movl   $0x80107417,0x4(%esp)
80104cf0:	80 
80104cf1:	89 1c 24             	mov    %ebx,(%esp)
80104cf4:	e8 97 ce ff ff       	call   80101b90 <namecmp>
80104cf9:	85 c0                	test   %eax,%eax
80104cfb:	0f 84 09 01 00 00    	je     80104e0a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104d01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d04:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d08:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d0c:	89 34 24             	mov    %esi,(%esp)
80104d0f:	e8 ac ce ff ff       	call   80101bc0 <dirlookup>
80104d14:	85 c0                	test   %eax,%eax
80104d16:	89 c3                	mov    %eax,%ebx
80104d18:	0f 84 ec 00 00 00    	je     80104e0a <sys_unlink+0x18a>
  ilock(ip);
80104d1e:	89 04 24             	mov    %eax,(%esp)
80104d21:	e8 8a c9 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
80104d26:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d2b:	0f 8e 24 01 00 00    	jle    80104e55 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d36:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104d39:	74 7d                	je     80104db8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104d3b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d42:	00 
80104d43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d4a:	00 
80104d4b:	89 34 24             	mov    %esi,(%esp)
80104d4e:	e8 fd f5 ff ff       	call   80104350 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104d56:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d5d:	00 
80104d5e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d62:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d69:	89 04 24             	mov    %eax,(%esp)
80104d6c:	e8 ef cc ff ff       	call   80101a60 <writei>
80104d71:	83 f8 10             	cmp    $0x10,%eax
80104d74:	0f 85 cf 00 00 00    	jne    80104e49 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104d7a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d7f:	0f 84 a3 00 00 00    	je     80104e28 <sys_unlink+0x1a8>
  iunlockput(dp);
80104d85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d88:	89 04 24             	mov    %eax,(%esp)
80104d8b:	e8 80 cb ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80104d90:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d95:	89 1c 24             	mov    %ebx,(%esp)
80104d98:	e8 53 c8 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104d9d:	89 1c 24             	mov    %ebx,(%esp)
80104da0:	e8 6b cb ff ff       	call   80101910 <iunlockput>
  end_op();
80104da5:	e8 26 de ff ff       	call   80102bd0 <end_op>
}
80104daa:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104dad:	31 c0                	xor    %eax,%eax
}
80104daf:	5b                   	pop    %ebx
80104db0:	5e                   	pop    %esi
80104db1:	5f                   	pop    %edi
80104db2:	5d                   	pop    %ebp
80104db3:	c3                   	ret    
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104db8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104dbc:	0f 86 79 ff ff ff    	jbe    80104d3b <sys_unlink+0xbb>
80104dc2:	bf 20 00 00 00       	mov    $0x20,%edi
80104dc7:	eb 15                	jmp    80104dde <sys_unlink+0x15e>
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd0:	8d 57 10             	lea    0x10(%edi),%edx
80104dd3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104dd6:	0f 83 5f ff ff ff    	jae    80104d3b <sys_unlink+0xbb>
80104ddc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dde:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104de5:	00 
80104de6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104dea:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dee:	89 1c 24             	mov    %ebx,(%esp)
80104df1:	e8 6a cb ff ff       	call   80101960 <readi>
80104df6:	83 f8 10             	cmp    $0x10,%eax
80104df9:	75 42                	jne    80104e3d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104dfb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e00:	74 ce                	je     80104dd0 <sys_unlink+0x150>
    iunlockput(ip);
80104e02:	89 1c 24             	mov    %ebx,(%esp)
80104e05:	e8 06 cb ff ff       	call   80101910 <iunlockput>
  iunlockput(dp);
80104e0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e0d:	89 04 24             	mov    %eax,(%esp)
80104e10:	e8 fb ca ff ff       	call   80101910 <iunlockput>
  end_op();
80104e15:	e8 b6 dd ff ff       	call   80102bd0 <end_op>
}
80104e1a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e22:	5b                   	pop    %ebx
80104e23:	5e                   	pop    %esi
80104e24:	5f                   	pop    %edi
80104e25:	5d                   	pop    %ebp
80104e26:	c3                   	ret    
80104e27:	90                   	nop
    dp->nlink--;
80104e28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e2b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e30:	89 04 24             	mov    %eax,(%esp)
80104e33:	e8 b8 c7 ff ff       	call   801015f0 <iupdate>
80104e38:	e9 48 ff ff ff       	jmp    80104d85 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104e3d:	c7 04 24 3c 74 10 80 	movl   $0x8010743c,(%esp)
80104e44:	e8 17 b5 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104e49:	c7 04 24 4e 74 10 80 	movl   $0x8010744e,(%esp)
80104e50:	e8 0b b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104e55:	c7 04 24 2a 74 10 80 	movl   $0x8010742a,(%esp)
80104e5c:	e8 ff b4 ff ff       	call   80100360 <panic>
80104e61:	eb 0d                	jmp    80104e70 <sys_open>
80104e63:	90                   	nop
80104e64:	90                   	nop
80104e65:	90                   	nop
80104e66:	90                   	nop
80104e67:	90                   	nop
80104e68:	90                   	nop
80104e69:	90                   	nop
80104e6a:	90                   	nop
80104e6b:	90                   	nop
80104e6c:	90                   	nop
80104e6d:	90                   	nop
80104e6e:	90                   	nop
80104e6f:	90                   	nop

80104e70 <sys_open>:

int
sys_open(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
80104e76:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e79:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e87:	e8 44 f8 ff ff       	call   801046d0 <argstr>
80104e8c:	85 c0                	test   %eax,%eax
80104e8e:	0f 88 d1 00 00 00    	js     80104f65 <sys_open+0xf5>
80104e94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ea2:	e8 99 f7 ff ff       	call   80104640 <argint>
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	0f 88 b6 00 00 00    	js     80104f65 <sys_open+0xf5>
    return -1;

  begin_op();
80104eaf:	e8 ac dc ff ff       	call   80102b60 <begin_op>

  if(omode & O_CREATE){
80104eb4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104eb8:	0f 85 82 00 00 00    	jne    80104f40 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ec1:	89 04 24             	mov    %eax,(%esp)
80104ec4:	e8 37 d0 ff ff       	call   80101f00 <namei>
80104ec9:	85 c0                	test   %eax,%eax
80104ecb:	89 c6                	mov    %eax,%esi
80104ecd:	0f 84 8d 00 00 00    	je     80104f60 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104ed3:	89 04 24             	mov    %eax,(%esp)
80104ed6:	e8 d5 c7 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104edb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104ee0:	0f 84 92 00 00 00    	je     80104f78 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104ee6:	e8 85 be ff ff       	call   80100d70 <filealloc>
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	89 c3                	mov    %eax,%ebx
80104eef:	0f 84 93 00 00 00    	je     80104f88 <sys_open+0x118>
80104ef5:	e8 86 f8 ff ff       	call   80104780 <fdalloc>
80104efa:	85 c0                	test   %eax,%eax
80104efc:	89 c7                	mov    %eax,%edi
80104efe:	0f 88 94 00 00 00    	js     80104f98 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f04:	89 34 24             	mov    %esi,(%esp)
80104f07:	e8 84 c8 ff ff       	call   80101790 <iunlock>
  end_op();
80104f0c:	e8 bf dc ff ff       	call   80102bd0 <end_op>

  f->type = FD_INODE;
80104f11:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104f1a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104f1d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104f24:	89 c2                	mov    %eax,%edx
80104f26:	83 e2 01             	and    $0x1,%edx
80104f29:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f2c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104f2e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104f31:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f33:	0f 95 43 09          	setne  0x9(%ebx)
}
80104f37:	83 c4 2c             	add    $0x2c,%esp
80104f3a:	5b                   	pop    %ebx
80104f3b:	5e                   	pop    %esi
80104f3c:	5f                   	pop    %edi
80104f3d:	5d                   	pop    %ebp
80104f3e:	c3                   	ret    
80104f3f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f43:	31 c9                	xor    %ecx,%ecx
80104f45:	ba 02 00 00 00       	mov    $0x2,%edx
80104f4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f51:	e8 6a f8 ff ff       	call   801047c0 <create>
    if(ip == 0){
80104f56:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104f58:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104f5a:	75 8a                	jne    80104ee6 <sys_open+0x76>
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104f60:	e8 6b dc ff ff       	call   80102bd0 <end_op>
}
80104f65:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	0f 84 63 ff ff ff    	je     80104ee6 <sys_open+0x76>
80104f83:	90                   	nop
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104f88:	89 34 24             	mov    %esi,(%esp)
80104f8b:	e8 80 c9 ff ff       	call   80101910 <iunlockput>
80104f90:	eb ce                	jmp    80104f60 <sys_open+0xf0>
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104f98:	89 1c 24             	mov    %ebx,(%esp)
80104f9b:	e8 90 be ff ff       	call   80100e30 <fileclose>
80104fa0:	eb e6                	jmp    80104f88 <sys_open+0x118>
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104fb6:	e8 a5 db ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104fbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc9:	e8 02 f7 ff ff       	call   801046d0 <argstr>
80104fce:	85 c0                	test   %eax,%eax
80104fd0:	78 2e                	js     80105000 <sys_mkdir+0x50>
80104fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd5:	31 c9                	xor    %ecx,%ecx
80104fd7:	ba 01 00 00 00       	mov    $0x1,%edx
80104fdc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fe3:	e8 d8 f7 ff ff       	call   801047c0 <create>
80104fe8:	85 c0                	test   %eax,%eax
80104fea:	74 14                	je     80105000 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fec:	89 04 24             	mov    %eax,(%esp)
80104fef:	e8 1c c9 ff ff       	call   80101910 <iunlockput>
  end_op();
80104ff4:	e8 d7 db ff ff       	call   80102bd0 <end_op>
  return 0;
80104ff9:	31 c0                	xor    %eax,%eax
}
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105000:	e8 cb db ff ff       	call   80102bd0 <end_op>
    return -1;
80105005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_mknod>:

int
sys_mknod(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105016:	e8 45 db ff ff       	call   80102b60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010501b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010501e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105029:	e8 a2 f6 ff ff       	call   801046d0 <argstr>
8010502e:	85 c0                	test   %eax,%eax
80105030:	78 5e                	js     80105090 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105032:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105035:	89 44 24 04          	mov    %eax,0x4(%esp)
80105039:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105040:	e8 fb f5 ff ff       	call   80104640 <argint>
  if((argstr(0, &path)) < 0 ||
80105045:	85 c0                	test   %eax,%eax
80105047:	78 47                	js     80105090 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105049:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010504c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105050:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105057:	e8 e4 f5 ff ff       	call   80104640 <argint>
     argint(1, &major) < 0 ||
8010505c:	85 c0                	test   %eax,%eax
8010505e:	78 30                	js     80105090 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105060:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105064:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105069:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010506d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80105070:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105073:	e8 48 f7 ff ff       	call   801047c0 <create>
80105078:	85 c0                	test   %eax,%eax
8010507a:	74 14                	je     80105090 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010507c:	89 04 24             	mov    %eax,(%esp)
8010507f:	e8 8c c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105084:	e8 47 db ff ff       	call   80102bd0 <end_op>
  return 0;
80105089:	31 c0                	xor    %eax,%eax
}
8010508b:	c9                   	leave  
8010508c:	c3                   	ret    
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105090:	e8 3b db ff ff       	call   80102bd0 <end_op>
    return -1;
80105095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_chdir>:

int
sys_chdir(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
801050a5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801050a8:	e8 43 e6 ff ff       	call   801036f0 <myproc>
801050ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801050af:	e8 ac da ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801050b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801050bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050c2:	e8 09 f6 ff ff       	call   801046d0 <argstr>
801050c7:	85 c0                	test   %eax,%eax
801050c9:	78 4a                	js     80105115 <sys_chdir+0x75>
801050cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ce:	89 04 24             	mov    %eax,(%esp)
801050d1:	e8 2a ce ff ff       	call   80101f00 <namei>
801050d6:	85 c0                	test   %eax,%eax
801050d8:	89 c3                	mov    %eax,%ebx
801050da:	74 39                	je     80105115 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801050dc:	89 04 24             	mov    %eax,(%esp)
801050df:	e8 cc c5 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801050e4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801050e9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
801050ec:	75 22                	jne    80105110 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
801050ee:	e8 9d c6 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
801050f3:	8b 46 68             	mov    0x68(%esi),%eax
801050f6:	89 04 24             	mov    %eax,(%esp)
801050f9:	e8 d2 c6 ff ff       	call   801017d0 <iput>
  end_op();
801050fe:	e8 cd da ff ff       	call   80102bd0 <end_op>
  curproc->cwd = ip;
  return 0;
80105103:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105105:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105108:	83 c4 20             	add    $0x20,%esp
8010510b:	5b                   	pop    %ebx
8010510c:	5e                   	pop    %esi
8010510d:	5d                   	pop    %ebp
8010510e:	c3                   	ret    
8010510f:	90                   	nop
    iunlockput(ip);
80105110:	e8 fb c7 ff ff       	call   80101910 <iunlockput>
    end_op();
80105115:	e8 b6 da ff ff       	call   80102bd0 <end_op>
}
8010511a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010511d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105122:	5b                   	pop    %ebx
80105123:	5e                   	pop    %esi
80105124:	5d                   	pop    %ebp
80105125:	c3                   	ret    
80105126:	8d 76 00             	lea    0x0(%esi),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_exec>:

int
sys_exec(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	53                   	push   %ebx
80105136:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010513c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105142:	89 44 24 04          	mov    %eax,0x4(%esp)
80105146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010514d:	e8 7e f5 ff ff       	call   801046d0 <argstr>
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 88 84 00 00 00    	js     801051de <sys_exec+0xae>
8010515a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105160:	89 44 24 04          	mov    %eax,0x4(%esp)
80105164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010516b:	e8 d0 f4 ff ff       	call   80104640 <argint>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 6a                	js     801051de <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105174:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010517a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010517c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105183:	00 
80105184:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010518a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105191:	00 
80105192:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105198:	89 04 24             	mov    %eax,(%esp)
8010519b:	e8 b0 f1 ff ff       	call   80104350 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801051a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801051a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801051aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801051ad:	89 04 24             	mov    %eax,(%esp)
801051b0:	e8 eb f3 ff ff       	call   801045a0 <fetchint>
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 25                	js     801051de <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801051b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801051bf:	85 c0                	test   %eax,%eax
801051c1:	74 2d                	je     801051f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801051c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801051c7:	89 04 24             	mov    %eax,(%esp)
801051ca:	e8 11 f4 ff ff       	call   801045e0 <fetchstr>
801051cf:	85 c0                	test   %eax,%eax
801051d1:	78 0b                	js     801051de <sys_exec+0xae>
  for(i=0;; i++){
801051d3:	83 c3 01             	add    $0x1,%ebx
801051d6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801051d9:	83 fb 20             	cmp    $0x20,%ebx
801051dc:	75 c2                	jne    801051a0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801051de:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801051e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051e9:	5b                   	pop    %ebx
801051ea:	5e                   	pop    %esi
801051eb:	5f                   	pop    %edi
801051ec:	5d                   	pop    %ebp
801051ed:	c3                   	ret    
801051ee:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801051f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801051f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801051fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105200:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105207:	00 00 00 00 
  return exec(path, argv);
8010520b:	89 04 24             	mov    %eax,(%esp)
8010520e:	e8 8d b7 ff ff       	call   801009a0 <exec>
}
80105213:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5f                   	pop    %edi
8010521c:	5d                   	pop    %ebp
8010521d:	c3                   	ret    
8010521e:	66 90                	xchg   %ax,%ax

80105220 <sys_pipe>:

int
sys_pipe(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	53                   	push   %ebx
80105224:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105227:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010522a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105231:	00 
80105232:	89 44 24 04          	mov    %eax,0x4(%esp)
80105236:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010523d:	e8 2e f4 ff ff       	call   80104670 <argptr>
80105242:	85 c0                	test   %eax,%eax
80105244:	78 6d                	js     801052b3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105246:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105249:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105250:	89 04 24             	mov    %eax,(%esp)
80105253:	e8 68 df ff ff       	call   801031c0 <pipealloc>
80105258:	85 c0                	test   %eax,%eax
8010525a:	78 57                	js     801052b3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010525c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525f:	e8 1c f5 ff ff       	call   80104780 <fdalloc>
80105264:	85 c0                	test   %eax,%eax
80105266:	89 c3                	mov    %eax,%ebx
80105268:	78 33                	js     8010529d <sys_pipe+0x7d>
8010526a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010526d:	e8 0e f5 ff ff       	call   80104780 <fdalloc>
80105272:	85 c0                	test   %eax,%eax
80105274:	78 1a                	js     80105290 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105276:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105279:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010527b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010527e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105281:	83 c4 24             	add    $0x24,%esp
  return 0;
80105284:	31 c0                	xor    %eax,%eax
}
80105286:	5b                   	pop    %ebx
80105287:	5d                   	pop    %ebp
80105288:	c3                   	ret    
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105290:	e8 5b e4 ff ff       	call   801036f0 <myproc>
80105295:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010529c:	00 
    fileclose(rf);
8010529d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052a0:	89 04 24             	mov    %eax,(%esp)
801052a3:	e8 88 bb ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801052a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ab:	89 04 24             	mov    %eax,(%esp)
801052ae:	e8 7d bb ff ff       	call   80100e30 <fileclose>
}
801052b3:	83 c4 24             	add    $0x24,%esp
    return -1;
801052b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052bb:	5b                   	pop    %ebx
801052bc:	5d                   	pop    %ebp
801052bd:	c3                   	ret    
801052be:	66 90                	xchg   %ax,%ax

801052c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052c3:	5d                   	pop    %ebp
  return fork();
801052c4:	e9 d7 e5 ff ff       	jmp    801038a0 <fork>
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_exit>:

int
sys_exit(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052d6:	e8 15 e8 ff ff       	call   80103af0 <exit>
  return 0;  // not reached
}
801052db:	31 c0                	xor    %eax,%eax
801052dd:	c9                   	leave  
801052de:	c3                   	ret    
801052df:	90                   	nop

801052e0 <sys_wait>:

int
sys_wait(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052e3:	5d                   	pop    %ebp
  return wait();
801052e4:	e9 17 ea ff ff       	jmp    80103d00 <wait>
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_kill>:

int
sys_kill(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105304:	e8 37 f3 ff ff       	call   80104640 <argint>
80105309:	85 c0                	test   %eax,%eax
8010530b:	78 13                	js     80105320 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010530d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105310:	89 04 24             	mov    %eax,(%esp)
80105313:	e8 28 eb ff ff       	call   80103e40 <kill>
}
80105318:	c9                   	leave  
80105319:	c3                   	ret    
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_getpid>:

int
sys_getpid(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105336:	e8 b5 e3 ff ff       	call   801036f0 <myproc>
8010533b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010533e:	c9                   	leave  
8010533f:	c3                   	ret    

80105340 <sys_sbrk>:

int
sys_sbrk(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	53                   	push   %ebx
80105344:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105347:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010534a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010534e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105355:	e8 e6 f2 ff ff       	call   80104640 <argint>
8010535a:	85 c0                	test   %eax,%eax
8010535c:	78 22                	js     80105380 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010535e:	e8 8d e3 ff ff       	call   801036f0 <myproc>
  if(growproc(n) < 0)
80105363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105366:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105368:	89 14 24             	mov    %edx,(%esp)
8010536b:	e8 c0 e4 ff ff       	call   80103830 <growproc>
80105370:	85 c0                	test   %eax,%eax
80105372:	78 0c                	js     80105380 <sys_sbrk+0x40>
    return -1;
  return addr;
80105374:	89 d8                	mov    %ebx,%eax
}
80105376:	83 c4 24             	add    $0x24,%esp
80105379:	5b                   	pop    %ebx
8010537a:	5d                   	pop    %ebp
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105385:	eb ef                	jmp    80105376 <sys_sbrk+0x36>
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_sleep>:

int
sys_sleep(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105397:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010539e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a5:	e8 96 f2 ff ff       	call   80104640 <argint>
801053aa:	85 c0                	test   %eax,%eax
801053ac:	78 7e                	js     8010542c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801053ae:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
801053b5:	e8 d6 ee ff ff       	call   80104290 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801053bd:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  while(ticks - ticks0 < n){
801053c3:	85 d2                	test   %edx,%edx
801053c5:	75 29                	jne    801053f0 <sys_sleep+0x60>
801053c7:	eb 4f                	jmp    80105418 <sys_sleep+0x88>
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053d0:	c7 44 24 04 80 4c 11 	movl   $0x80114c80,0x4(%esp)
801053d7:	80 
801053d8:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
801053df:	e8 6c e8 ff ff       	call   80103c50 <sleep>
  while(ticks - ticks0 < n){
801053e4:	a1 c0 54 11 80       	mov    0x801154c0,%eax
801053e9:	29 d8                	sub    %ebx,%eax
801053eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053ee:	73 28                	jae    80105418 <sys_sleep+0x88>
    if(myproc()->killed){
801053f0:	e8 fb e2 ff ff       	call   801036f0 <myproc>
801053f5:	8b 40 24             	mov    0x24(%eax),%eax
801053f8:	85 c0                	test   %eax,%eax
801053fa:	74 d4                	je     801053d0 <sys_sleep+0x40>
      release(&tickslock);
801053fc:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105403:	e8 f8 ee ff ff       	call   80104300 <release>
      return -1;
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010540d:	83 c4 24             	add    $0x24,%esp
80105410:	5b                   	pop    %ebx
80105411:	5d                   	pop    %ebp
80105412:	c3                   	ret    
80105413:	90                   	nop
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105418:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
8010541f:	e8 dc ee ff ff       	call   80104300 <release>
}
80105424:	83 c4 24             	add    $0x24,%esp
  return 0;
80105427:	31 c0                	xor    %eax,%eax
}
80105429:	5b                   	pop    %ebx
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    
    return -1;
8010542c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105431:	eb da                	jmp    8010540d <sys_sleep+0x7d>
80105433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105447:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
8010544e:	e8 3d ee ff ff       	call   80104290 <acquire>
  xticks = ticks;
80105453:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  release(&tickslock);
80105459:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105460:	e8 9b ee ff ff       	call   80104300 <release>
  return xticks;
}
80105465:	83 c4 14             	add    $0x14,%esp
80105468:	89 d8                	mov    %ebx,%eax
8010546a:	5b                   	pop    %ebx
8010546b:	5d                   	pop    %ebp
8010546c:	c3                   	ret    
8010546d:	8d 76 00             	lea    0x0(%esi),%esi

80105470 <sys_sysinfo>:


int sys_sysinfo(void) { // sysinfo syscall definition
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 28             	sub    $0x28,%esp
  int n;
  argint(0, &n);
80105476:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105479:	89 44 24 04          	mov    %eax,0x4(%esp)
8010547d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105484:	e8 b7 f1 ff ff       	call   80104640 <argint>
  return sysinfo(n);
80105489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010548c:	89 04 24             	mov    %eax,(%esp)
8010548f:	e8 fc ea ff ff       	call   80103f90 <sysinfo>
}
80105494:	c9                   	leave  
80105495:	c3                   	ret    

80105496 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105496:	1e                   	push   %ds
  pushl %es
80105497:	06                   	push   %es
  pushl %fs
80105498:	0f a0                	push   %fs
  pushl %gs
8010549a:	0f a8                	push   %gs
  pushal
8010549c:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010549d:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801054a1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801054a3:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801054a5:	54                   	push   %esp
  call trap
801054a6:	e8 e5 00 00 00       	call   80105590 <trap>
  addl $4, %esp
801054ab:	83 c4 04             	add    $0x4,%esp

801054ae <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801054ae:	61                   	popa   
  popl %gs
801054af:	0f a9                	pop    %gs
  popl %fs
801054b1:	0f a1                	pop    %fs
  popl %es
801054b3:	07                   	pop    %es
  popl %ds
801054b4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801054b5:	83 c4 08             	add    $0x8,%esp
  iret
801054b8:	cf                   	iret   
801054b9:	66 90                	xchg   %ax,%ax
801054bb:	66 90                	xchg   %ax,%ax
801054bd:	66 90                	xchg   %ax,%ax
801054bf:	90                   	nop

801054c0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801054c0:	31 c0                	xor    %eax,%eax
801054c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801054c8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801054cf:	b9 08 00 00 00       	mov    $0x8,%ecx
801054d4:	66 89 0c c5 c2 4c 11 	mov    %cx,-0x7feeb33e(,%eax,8)
801054db:	80 
801054dc:	c6 04 c5 c4 4c 11 80 	movb   $0x0,-0x7feeb33c(,%eax,8)
801054e3:	00 
801054e4:	c6 04 c5 c5 4c 11 80 	movb   $0x8e,-0x7feeb33b(,%eax,8)
801054eb:	8e 
801054ec:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
801054f3:	80 
801054f4:	c1 ea 10             	shr    $0x10,%edx
801054f7:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
801054fe:	80 
  for(i = 0; i < 256; i++)
801054ff:	83 c0 01             	add    $0x1,%eax
80105502:	3d 00 01 00 00       	cmp    $0x100,%eax
80105507:	75 bf                	jne    801054c8 <tvinit+0x8>
{
80105509:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010550a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010550f:	89 e5                	mov    %esp,%ebp
80105511:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105514:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105519:	c7 44 24 04 5d 74 10 	movl   $0x8010745d,0x4(%esp)
80105520:	80 
80105521:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105528:	66 89 15 c2 4e 11 80 	mov    %dx,0x80114ec2
8010552f:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105535:	c1 e8 10             	shr    $0x10,%eax
80105538:	c6 05 c4 4e 11 80 00 	movb   $0x0,0x80114ec4
8010553f:	c6 05 c5 4e 11 80 ef 	movb   $0xef,0x80114ec5
80105546:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
8010554c:	e8 cf eb ff ff       	call   80104120 <initlock>
}
80105551:	c9                   	leave  
80105552:	c3                   	ret    
80105553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <idtinit>:

void
idtinit(void)
{
80105560:	55                   	push   %ebp
  pd[0] = size-1;
80105561:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105566:	89 e5                	mov    %esp,%ebp
80105568:	83 ec 10             	sub    $0x10,%esp
8010556b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010556f:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105574:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105578:	c1 e8 10             	shr    $0x10,%eax
8010557b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010557f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105582:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105585:	c9                   	leave  
80105586:	c3                   	ret    
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
80105595:	53                   	push   %ebx
80105596:	83 ec 3c             	sub    $0x3c,%esp
80105599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010559c:	8b 43 30             	mov    0x30(%ebx),%eax
8010559f:	83 f8 40             	cmp    $0x40,%eax
801055a2:	0f 84 a0 01 00 00    	je     80105748 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801055a8:	83 e8 20             	sub    $0x20,%eax
801055ab:	83 f8 1f             	cmp    $0x1f,%eax
801055ae:	77 08                	ja     801055b8 <trap+0x28>
801055b0:	ff 24 85 04 75 10 80 	jmp    *-0x7fef8afc(,%eax,4)
801055b7:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801055b8:	e8 33 e1 ff ff       	call   801036f0 <myproc>
801055bd:	85 c0                	test   %eax,%eax
801055bf:	90                   	nop
801055c0:	0f 84 fa 01 00 00    	je     801057c0 <trap+0x230>
801055c6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801055ca:	0f 84 f0 01 00 00    	je     801057c0 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801055d0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055d3:	8b 53 38             	mov    0x38(%ebx),%edx
801055d6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801055d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
801055dc:	e8 ef e0 ff ff       	call   801036d0 <cpuid>
801055e1:	8b 73 30             	mov    0x30(%ebx),%esi
801055e4:	89 c7                	mov    %eax,%edi
801055e6:	8b 43 34             	mov    0x34(%ebx),%eax
801055e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055ec:	e8 ff e0 ff ff       	call   801036f0 <myproc>
801055f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055f4:	e8 f7 e0 ff ff       	call   801036f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801055fc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105600:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105603:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105606:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010560a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010560e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105611:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105614:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105618:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010561c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105620:	8b 40 10             	mov    0x10(%eax),%eax
80105623:	c7 04 24 c0 74 10 80 	movl   $0x801074c0,(%esp)
8010562a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010562e:	e8 1d b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105633:	e8 b8 e0 ff ff       	call   801036f0 <myproc>
80105638:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010563f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105640:	e8 ab e0 ff ff       	call   801036f0 <myproc>
80105645:	85 c0                	test   %eax,%eax
80105647:	74 0c                	je     80105655 <trap+0xc5>
80105649:	e8 a2 e0 ff ff       	call   801036f0 <myproc>
8010564e:	8b 50 24             	mov    0x24(%eax),%edx
80105651:	85 d2                	test   %edx,%edx
80105653:	75 4b                	jne    801056a0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105655:	e8 96 e0 ff ff       	call   801036f0 <myproc>
8010565a:	85 c0                	test   %eax,%eax
8010565c:	74 0d                	je     8010566b <trap+0xdb>
8010565e:	66 90                	xchg   %ax,%ax
80105660:	e8 8b e0 ff ff       	call   801036f0 <myproc>
80105665:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105669:	74 4d                	je     801056b8 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010566b:	e8 80 e0 ff ff       	call   801036f0 <myproc>
80105670:	85 c0                	test   %eax,%eax
80105672:	74 1d                	je     80105691 <trap+0x101>
80105674:	e8 77 e0 ff ff       	call   801036f0 <myproc>
80105679:	8b 40 24             	mov    0x24(%eax),%eax
8010567c:	85 c0                	test   %eax,%eax
8010567e:	74 11                	je     80105691 <trap+0x101>
80105680:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105684:	83 e0 03             	and    $0x3,%eax
80105687:	66 83 f8 03          	cmp    $0x3,%ax
8010568b:	0f 84 e8 00 00 00    	je     80105779 <trap+0x1e9>
    exit();
}
80105691:	83 c4 3c             	add    $0x3c,%esp
80105694:	5b                   	pop    %ebx
80105695:	5e                   	pop    %esi
80105696:	5f                   	pop    %edi
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056a0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056a4:	83 e0 03             	and    $0x3,%eax
801056a7:	66 83 f8 03          	cmp    $0x3,%ax
801056ab:	75 a8                	jne    80105655 <trap+0xc5>
    exit();
801056ad:	e8 3e e4 ff ff       	call   80103af0 <exit>
801056b2:	eb a1                	jmp    80105655 <trap+0xc5>
801056b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801056b8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056c0:	75 a9                	jne    8010566b <trap+0xdb>
    yield();
801056c2:	e8 49 e5 ff ff       	call   80103c10 <yield>
801056c7:	eb a2                	jmp    8010566b <trap+0xdb>
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801056d0:	e8 fb df ff ff       	call   801036d0 <cpuid>
801056d5:	85 c0                	test   %eax,%eax
801056d7:	0f 84 b3 00 00 00    	je     80105790 <trap+0x200>
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
801056e0:	e8 eb d0 ff ff       	call   801027d0 <lapiceoi>
    break;
801056e5:	e9 56 ff ff ff       	jmp    80105640 <trap+0xb0>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
801056f0:	e8 2b cf ff ff       	call   80102620 <kbdintr>
    lapiceoi();
801056f5:	e8 d6 d0 ff ff       	call   801027d0 <lapiceoi>
    break;
801056fa:	e9 41 ff ff ff       	jmp    80105640 <trap+0xb0>
801056ff:	90                   	nop
    uartintr();
80105700:	e8 1b 02 00 00       	call   80105920 <uartintr>
    lapiceoi();
80105705:	e8 c6 d0 ff ff       	call   801027d0 <lapiceoi>
    break;
8010570a:	e9 31 ff ff ff       	jmp    80105640 <trap+0xb0>
8010570f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105710:	8b 7b 38             	mov    0x38(%ebx),%edi
80105713:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105717:	e8 b4 df ff ff       	call   801036d0 <cpuid>
8010571c:	c7 04 24 68 74 10 80 	movl   $0x80107468,(%esp)
80105723:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105727:	89 74 24 08          	mov    %esi,0x8(%esp)
8010572b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010572f:	e8 1c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105734:	e8 97 d0 ff ff       	call   801027d0 <lapiceoi>
    break;
80105739:	e9 02 ff ff ff       	jmp    80105640 <trap+0xb0>
8010573e:	66 90                	xchg   %ax,%ax
    ideintr();
80105740:	e8 3b c9 ff ff       	call   80102080 <ideintr>
80105745:	eb 96                	jmp    801056dd <trap+0x14d>
80105747:	90                   	nop
80105748:	90                   	nop
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105750:	e8 9b df ff ff       	call   801036f0 <myproc>
80105755:	8b 70 24             	mov    0x24(%eax),%esi
80105758:	85 f6                	test   %esi,%esi
8010575a:	75 2c                	jne    80105788 <trap+0x1f8>
    myproc()->tf = tf;
8010575c:	e8 8f df ff ff       	call   801036f0 <myproc>
80105761:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105764:	e8 a7 ef ff ff       	call   80104710 <syscall>
    if(myproc()->killed)
80105769:	e8 82 df ff ff       	call   801036f0 <myproc>
8010576e:	8b 48 24             	mov    0x24(%eax),%ecx
80105771:	85 c9                	test   %ecx,%ecx
80105773:	0f 84 18 ff ff ff    	je     80105691 <trap+0x101>
}
80105779:	83 c4 3c             	add    $0x3c,%esp
8010577c:	5b                   	pop    %ebx
8010577d:	5e                   	pop    %esi
8010577e:	5f                   	pop    %edi
8010577f:	5d                   	pop    %ebp
      exit();
80105780:	e9 6b e3 ff ff       	jmp    80103af0 <exit>
80105785:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105788:	e8 63 e3 ff ff       	call   80103af0 <exit>
8010578d:	eb cd                	jmp    8010575c <trap+0x1cc>
8010578f:	90                   	nop
      acquire(&tickslock);
80105790:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105797:	e8 f4 ea ff ff       	call   80104290 <acquire>
      wakeup(&ticks);
8010579c:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
      ticks++;
801057a3:	83 05 c0 54 11 80 01 	addl   $0x1,0x801154c0
      wakeup(&ticks);
801057aa:	e8 31 e6 ff ff       	call   80103de0 <wakeup>
      release(&tickslock);
801057af:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
801057b6:	e8 45 eb ff ff       	call   80104300 <release>
801057bb:	e9 1d ff ff ff       	jmp    801056dd <trap+0x14d>
801057c0:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801057c3:	8b 73 38             	mov    0x38(%ebx),%esi
801057c6:	e8 05 df ff ff       	call   801036d0 <cpuid>
801057cb:	89 7c 24 10          	mov    %edi,0x10(%esp)
801057cf:	89 74 24 0c          	mov    %esi,0xc(%esp)
801057d3:	89 44 24 08          	mov    %eax,0x8(%esp)
801057d7:	8b 43 30             	mov    0x30(%ebx),%eax
801057da:	c7 04 24 8c 74 10 80 	movl   $0x8010748c,(%esp)
801057e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e5:	e8 66 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
801057ea:	c7 04 24 62 74 10 80 	movl   $0x80107462,(%esp)
801057f1:	e8 6a ab ff ff       	call   80100360 <panic>
801057f6:	66 90                	xchg   %ax,%ax
801057f8:	66 90                	xchg   %ax,%ax
801057fa:	66 90                	xchg   %ax,%ax
801057fc:	66 90                	xchg   %ax,%ax
801057fe:	66 90                	xchg   %ax,%ax

80105800 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105800:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105805:	55                   	push   %ebp
80105806:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105808:	85 c0                	test   %eax,%eax
8010580a:	74 14                	je     80105820 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010580c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105811:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105812:	a8 01                	test   $0x1,%al
80105814:	74 0a                	je     80105820 <uartgetc+0x20>
80105816:	b2 f8                	mov    $0xf8,%dl
80105818:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105819:	0f b6 c0             	movzbl %al,%eax
}
8010581c:	5d                   	pop    %ebp
8010581d:	c3                   	ret    
8010581e:	66 90                	xchg   %ax,%ax
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105825:	5d                   	pop    %ebp
80105826:	c3                   	ret    
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <uartputc>:
  if(!uart)
80105830:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105835:	85 c0                	test   %eax,%eax
80105837:	74 3f                	je     80105878 <uartputc+0x48>
{
80105839:	55                   	push   %ebp
8010583a:	89 e5                	mov    %esp,%ebp
8010583c:	56                   	push   %esi
8010583d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105842:	53                   	push   %ebx
  if(!uart)
80105843:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105848:	83 ec 10             	sub    $0x10,%esp
8010584b:	eb 14                	jmp    80105861 <uartputc+0x31>
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105850:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105857:	e8 94 cf ff ff       	call   801027f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010585c:	83 eb 01             	sub    $0x1,%ebx
8010585f:	74 07                	je     80105868 <uartputc+0x38>
80105861:	89 f2                	mov    %esi,%edx
80105863:	ec                   	in     (%dx),%al
80105864:	a8 20                	test   $0x20,%al
80105866:	74 e8                	je     80105850 <uartputc+0x20>
  outb(COM1+0, c);
80105868:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010586c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105871:	ee                   	out    %al,(%dx)
}
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5d                   	pop    %ebp
80105878:	f3 c3                	repz ret 
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <uartinit>:
{
80105880:	55                   	push   %ebp
80105881:	31 c9                	xor    %ecx,%ecx
80105883:	89 e5                	mov    %esp,%ebp
80105885:	89 c8                	mov    %ecx,%eax
80105887:	57                   	push   %edi
80105888:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010588d:	56                   	push   %esi
8010588e:	89 fa                	mov    %edi,%edx
80105890:	53                   	push   %ebx
80105891:	83 ec 1c             	sub    $0x1c,%esp
80105894:	ee                   	out    %al,(%dx)
80105895:	be fb 03 00 00       	mov    $0x3fb,%esi
8010589a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010589f:	89 f2                	mov    %esi,%edx
801058a1:	ee                   	out    %al,(%dx)
801058a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801058a7:	b2 f8                	mov    $0xf8,%dl
801058a9:	ee                   	out    %al,(%dx)
801058aa:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801058af:	89 c8                	mov    %ecx,%eax
801058b1:	89 da                	mov    %ebx,%edx
801058b3:	ee                   	out    %al,(%dx)
801058b4:	b8 03 00 00 00       	mov    $0x3,%eax
801058b9:	89 f2                	mov    %esi,%edx
801058bb:	ee                   	out    %al,(%dx)
801058bc:	b2 fc                	mov    $0xfc,%dl
801058be:	89 c8                	mov    %ecx,%eax
801058c0:	ee                   	out    %al,(%dx)
801058c1:	b8 01 00 00 00       	mov    $0x1,%eax
801058c6:	89 da                	mov    %ebx,%edx
801058c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058c9:	b2 fd                	mov    $0xfd,%dl
801058cb:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801058cc:	3c ff                	cmp    $0xff,%al
801058ce:	74 42                	je     80105912 <uartinit+0x92>
  uart = 1;
801058d0:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801058d7:	00 00 00 
801058da:	89 fa                	mov    %edi,%edx
801058dc:	ec                   	in     (%dx),%al
801058dd:	b2 f8                	mov    $0xf8,%dl
801058df:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801058e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058e7:	00 
  for(p="xv6...\n"; *p; p++)
801058e8:	bb 84 75 10 80       	mov    $0x80107584,%ebx
  ioapicenable(IRQ_COM1, 0);
801058ed:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801058f4:	e8 b7 c9 ff ff       	call   801022b0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801058f9:	b8 78 00 00 00       	mov    $0x78,%eax
801058fe:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105900:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105903:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105906:	e8 25 ff ff ff       	call   80105830 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010590b:	0f be 03             	movsbl (%ebx),%eax
8010590e:	84 c0                	test   %al,%al
80105910:	75 ee                	jne    80105900 <uartinit+0x80>
}
80105912:	83 c4 1c             	add    $0x1c,%esp
80105915:	5b                   	pop    %ebx
80105916:	5e                   	pop    %esi
80105917:	5f                   	pop    %edi
80105918:	5d                   	pop    %ebp
80105919:	c3                   	ret    
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105920 <uartintr>:

void
uartintr(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105926:	c7 04 24 00 58 10 80 	movl   $0x80105800,(%esp)
8010592d:	e8 7e ae ff ff       	call   801007b0 <consoleintr>
}
80105932:	c9                   	leave  
80105933:	c3                   	ret    

80105934 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105934:	6a 00                	push   $0x0
  pushl $0
80105936:	6a 00                	push   $0x0
  jmp alltraps
80105938:	e9 59 fb ff ff       	jmp    80105496 <alltraps>

8010593d <vector1>:
.globl vector1
vector1:
  pushl $0
8010593d:	6a 00                	push   $0x0
  pushl $1
8010593f:	6a 01                	push   $0x1
  jmp alltraps
80105941:	e9 50 fb ff ff       	jmp    80105496 <alltraps>

80105946 <vector2>:
.globl vector2
vector2:
  pushl $0
80105946:	6a 00                	push   $0x0
  pushl $2
80105948:	6a 02                	push   $0x2
  jmp alltraps
8010594a:	e9 47 fb ff ff       	jmp    80105496 <alltraps>

8010594f <vector3>:
.globl vector3
vector3:
  pushl $0
8010594f:	6a 00                	push   $0x0
  pushl $3
80105951:	6a 03                	push   $0x3
  jmp alltraps
80105953:	e9 3e fb ff ff       	jmp    80105496 <alltraps>

80105958 <vector4>:
.globl vector4
vector4:
  pushl $0
80105958:	6a 00                	push   $0x0
  pushl $4
8010595a:	6a 04                	push   $0x4
  jmp alltraps
8010595c:	e9 35 fb ff ff       	jmp    80105496 <alltraps>

80105961 <vector5>:
.globl vector5
vector5:
  pushl $0
80105961:	6a 00                	push   $0x0
  pushl $5
80105963:	6a 05                	push   $0x5
  jmp alltraps
80105965:	e9 2c fb ff ff       	jmp    80105496 <alltraps>

8010596a <vector6>:
.globl vector6
vector6:
  pushl $0
8010596a:	6a 00                	push   $0x0
  pushl $6
8010596c:	6a 06                	push   $0x6
  jmp alltraps
8010596e:	e9 23 fb ff ff       	jmp    80105496 <alltraps>

80105973 <vector7>:
.globl vector7
vector7:
  pushl $0
80105973:	6a 00                	push   $0x0
  pushl $7
80105975:	6a 07                	push   $0x7
  jmp alltraps
80105977:	e9 1a fb ff ff       	jmp    80105496 <alltraps>

8010597c <vector8>:
.globl vector8
vector8:
  pushl $8
8010597c:	6a 08                	push   $0x8
  jmp alltraps
8010597e:	e9 13 fb ff ff       	jmp    80105496 <alltraps>

80105983 <vector9>:
.globl vector9
vector9:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $9
80105985:	6a 09                	push   $0x9
  jmp alltraps
80105987:	e9 0a fb ff ff       	jmp    80105496 <alltraps>

8010598c <vector10>:
.globl vector10
vector10:
  pushl $10
8010598c:	6a 0a                	push   $0xa
  jmp alltraps
8010598e:	e9 03 fb ff ff       	jmp    80105496 <alltraps>

80105993 <vector11>:
.globl vector11
vector11:
  pushl $11
80105993:	6a 0b                	push   $0xb
  jmp alltraps
80105995:	e9 fc fa ff ff       	jmp    80105496 <alltraps>

8010599a <vector12>:
.globl vector12
vector12:
  pushl $12
8010599a:	6a 0c                	push   $0xc
  jmp alltraps
8010599c:	e9 f5 fa ff ff       	jmp    80105496 <alltraps>

801059a1 <vector13>:
.globl vector13
vector13:
  pushl $13
801059a1:	6a 0d                	push   $0xd
  jmp alltraps
801059a3:	e9 ee fa ff ff       	jmp    80105496 <alltraps>

801059a8 <vector14>:
.globl vector14
vector14:
  pushl $14
801059a8:	6a 0e                	push   $0xe
  jmp alltraps
801059aa:	e9 e7 fa ff ff       	jmp    80105496 <alltraps>

801059af <vector15>:
.globl vector15
vector15:
  pushl $0
801059af:	6a 00                	push   $0x0
  pushl $15
801059b1:	6a 0f                	push   $0xf
  jmp alltraps
801059b3:	e9 de fa ff ff       	jmp    80105496 <alltraps>

801059b8 <vector16>:
.globl vector16
vector16:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $16
801059ba:	6a 10                	push   $0x10
  jmp alltraps
801059bc:	e9 d5 fa ff ff       	jmp    80105496 <alltraps>

801059c1 <vector17>:
.globl vector17
vector17:
  pushl $17
801059c1:	6a 11                	push   $0x11
  jmp alltraps
801059c3:	e9 ce fa ff ff       	jmp    80105496 <alltraps>

801059c8 <vector18>:
.globl vector18
vector18:
  pushl $0
801059c8:	6a 00                	push   $0x0
  pushl $18
801059ca:	6a 12                	push   $0x12
  jmp alltraps
801059cc:	e9 c5 fa ff ff       	jmp    80105496 <alltraps>

801059d1 <vector19>:
.globl vector19
vector19:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $19
801059d3:	6a 13                	push   $0x13
  jmp alltraps
801059d5:	e9 bc fa ff ff       	jmp    80105496 <alltraps>

801059da <vector20>:
.globl vector20
vector20:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $20
801059dc:	6a 14                	push   $0x14
  jmp alltraps
801059de:	e9 b3 fa ff ff       	jmp    80105496 <alltraps>

801059e3 <vector21>:
.globl vector21
vector21:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $21
801059e5:	6a 15                	push   $0x15
  jmp alltraps
801059e7:	e9 aa fa ff ff       	jmp    80105496 <alltraps>

801059ec <vector22>:
.globl vector22
vector22:
  pushl $0
801059ec:	6a 00                	push   $0x0
  pushl $22
801059ee:	6a 16                	push   $0x16
  jmp alltraps
801059f0:	e9 a1 fa ff ff       	jmp    80105496 <alltraps>

801059f5 <vector23>:
.globl vector23
vector23:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $23
801059f7:	6a 17                	push   $0x17
  jmp alltraps
801059f9:	e9 98 fa ff ff       	jmp    80105496 <alltraps>

801059fe <vector24>:
.globl vector24
vector24:
  pushl $0
801059fe:	6a 00                	push   $0x0
  pushl $24
80105a00:	6a 18                	push   $0x18
  jmp alltraps
80105a02:	e9 8f fa ff ff       	jmp    80105496 <alltraps>

80105a07 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $25
80105a09:	6a 19                	push   $0x19
  jmp alltraps
80105a0b:	e9 86 fa ff ff       	jmp    80105496 <alltraps>

80105a10 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a10:	6a 00                	push   $0x0
  pushl $26
80105a12:	6a 1a                	push   $0x1a
  jmp alltraps
80105a14:	e9 7d fa ff ff       	jmp    80105496 <alltraps>

80105a19 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $27
80105a1b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a1d:	e9 74 fa ff ff       	jmp    80105496 <alltraps>

80105a22 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a22:	6a 00                	push   $0x0
  pushl $28
80105a24:	6a 1c                	push   $0x1c
  jmp alltraps
80105a26:	e9 6b fa ff ff       	jmp    80105496 <alltraps>

80105a2b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $29
80105a2d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a2f:	e9 62 fa ff ff       	jmp    80105496 <alltraps>

80105a34 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a34:	6a 00                	push   $0x0
  pushl $30
80105a36:	6a 1e                	push   $0x1e
  jmp alltraps
80105a38:	e9 59 fa ff ff       	jmp    80105496 <alltraps>

80105a3d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $31
80105a3f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a41:	e9 50 fa ff ff       	jmp    80105496 <alltraps>

80105a46 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $32
80105a48:	6a 20                	push   $0x20
  jmp alltraps
80105a4a:	e9 47 fa ff ff       	jmp    80105496 <alltraps>

80105a4f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $33
80105a51:	6a 21                	push   $0x21
  jmp alltraps
80105a53:	e9 3e fa ff ff       	jmp    80105496 <alltraps>

80105a58 <vector34>:
.globl vector34
vector34:
  pushl $0
80105a58:	6a 00                	push   $0x0
  pushl $34
80105a5a:	6a 22                	push   $0x22
  jmp alltraps
80105a5c:	e9 35 fa ff ff       	jmp    80105496 <alltraps>

80105a61 <vector35>:
.globl vector35
vector35:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $35
80105a63:	6a 23                	push   $0x23
  jmp alltraps
80105a65:	e9 2c fa ff ff       	jmp    80105496 <alltraps>

80105a6a <vector36>:
.globl vector36
vector36:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $36
80105a6c:	6a 24                	push   $0x24
  jmp alltraps
80105a6e:	e9 23 fa ff ff       	jmp    80105496 <alltraps>

80105a73 <vector37>:
.globl vector37
vector37:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $37
80105a75:	6a 25                	push   $0x25
  jmp alltraps
80105a77:	e9 1a fa ff ff       	jmp    80105496 <alltraps>

80105a7c <vector38>:
.globl vector38
vector38:
  pushl $0
80105a7c:	6a 00                	push   $0x0
  pushl $38
80105a7e:	6a 26                	push   $0x26
  jmp alltraps
80105a80:	e9 11 fa ff ff       	jmp    80105496 <alltraps>

80105a85 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $39
80105a87:	6a 27                	push   $0x27
  jmp alltraps
80105a89:	e9 08 fa ff ff       	jmp    80105496 <alltraps>

80105a8e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a8e:	6a 00                	push   $0x0
  pushl $40
80105a90:	6a 28                	push   $0x28
  jmp alltraps
80105a92:	e9 ff f9 ff ff       	jmp    80105496 <alltraps>

80105a97 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $41
80105a99:	6a 29                	push   $0x29
  jmp alltraps
80105a9b:	e9 f6 f9 ff ff       	jmp    80105496 <alltraps>

80105aa0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105aa0:	6a 00                	push   $0x0
  pushl $42
80105aa2:	6a 2a                	push   $0x2a
  jmp alltraps
80105aa4:	e9 ed f9 ff ff       	jmp    80105496 <alltraps>

80105aa9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $43
80105aab:	6a 2b                	push   $0x2b
  jmp alltraps
80105aad:	e9 e4 f9 ff ff       	jmp    80105496 <alltraps>

80105ab2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $44
80105ab4:	6a 2c                	push   $0x2c
  jmp alltraps
80105ab6:	e9 db f9 ff ff       	jmp    80105496 <alltraps>

80105abb <vector45>:
.globl vector45
vector45:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $45
80105abd:	6a 2d                	push   $0x2d
  jmp alltraps
80105abf:	e9 d2 f9 ff ff       	jmp    80105496 <alltraps>

80105ac4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105ac4:	6a 00                	push   $0x0
  pushl $46
80105ac6:	6a 2e                	push   $0x2e
  jmp alltraps
80105ac8:	e9 c9 f9 ff ff       	jmp    80105496 <alltraps>

80105acd <vector47>:
.globl vector47
vector47:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $47
80105acf:	6a 2f                	push   $0x2f
  jmp alltraps
80105ad1:	e9 c0 f9 ff ff       	jmp    80105496 <alltraps>

80105ad6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $48
80105ad8:	6a 30                	push   $0x30
  jmp alltraps
80105ada:	e9 b7 f9 ff ff       	jmp    80105496 <alltraps>

80105adf <vector49>:
.globl vector49
vector49:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $49
80105ae1:	6a 31                	push   $0x31
  jmp alltraps
80105ae3:	e9 ae f9 ff ff       	jmp    80105496 <alltraps>

80105ae8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ae8:	6a 00                	push   $0x0
  pushl $50
80105aea:	6a 32                	push   $0x32
  jmp alltraps
80105aec:	e9 a5 f9 ff ff       	jmp    80105496 <alltraps>

80105af1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $51
80105af3:	6a 33                	push   $0x33
  jmp alltraps
80105af5:	e9 9c f9 ff ff       	jmp    80105496 <alltraps>

80105afa <vector52>:
.globl vector52
vector52:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $52
80105afc:	6a 34                	push   $0x34
  jmp alltraps
80105afe:	e9 93 f9 ff ff       	jmp    80105496 <alltraps>

80105b03 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $53
80105b05:	6a 35                	push   $0x35
  jmp alltraps
80105b07:	e9 8a f9 ff ff       	jmp    80105496 <alltraps>

80105b0c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b0c:	6a 00                	push   $0x0
  pushl $54
80105b0e:	6a 36                	push   $0x36
  jmp alltraps
80105b10:	e9 81 f9 ff ff       	jmp    80105496 <alltraps>

80105b15 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $55
80105b17:	6a 37                	push   $0x37
  jmp alltraps
80105b19:	e9 78 f9 ff ff       	jmp    80105496 <alltraps>

80105b1e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $56
80105b20:	6a 38                	push   $0x38
  jmp alltraps
80105b22:	e9 6f f9 ff ff       	jmp    80105496 <alltraps>

80105b27 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $57
80105b29:	6a 39                	push   $0x39
  jmp alltraps
80105b2b:	e9 66 f9 ff ff       	jmp    80105496 <alltraps>

80105b30 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b30:	6a 00                	push   $0x0
  pushl $58
80105b32:	6a 3a                	push   $0x3a
  jmp alltraps
80105b34:	e9 5d f9 ff ff       	jmp    80105496 <alltraps>

80105b39 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $59
80105b3b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b3d:	e9 54 f9 ff ff       	jmp    80105496 <alltraps>

80105b42 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $60
80105b44:	6a 3c                	push   $0x3c
  jmp alltraps
80105b46:	e9 4b f9 ff ff       	jmp    80105496 <alltraps>

80105b4b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $61
80105b4d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b4f:	e9 42 f9 ff ff       	jmp    80105496 <alltraps>

80105b54 <vector62>:
.globl vector62
vector62:
  pushl $0
80105b54:	6a 00                	push   $0x0
  pushl $62
80105b56:	6a 3e                	push   $0x3e
  jmp alltraps
80105b58:	e9 39 f9 ff ff       	jmp    80105496 <alltraps>

80105b5d <vector63>:
.globl vector63
vector63:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $63
80105b5f:	6a 3f                	push   $0x3f
  jmp alltraps
80105b61:	e9 30 f9 ff ff       	jmp    80105496 <alltraps>

80105b66 <vector64>:
.globl vector64
vector64:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $64
80105b68:	6a 40                	push   $0x40
  jmp alltraps
80105b6a:	e9 27 f9 ff ff       	jmp    80105496 <alltraps>

80105b6f <vector65>:
.globl vector65
vector65:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $65
80105b71:	6a 41                	push   $0x41
  jmp alltraps
80105b73:	e9 1e f9 ff ff       	jmp    80105496 <alltraps>

80105b78 <vector66>:
.globl vector66
vector66:
  pushl $0
80105b78:	6a 00                	push   $0x0
  pushl $66
80105b7a:	6a 42                	push   $0x42
  jmp alltraps
80105b7c:	e9 15 f9 ff ff       	jmp    80105496 <alltraps>

80105b81 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $67
80105b83:	6a 43                	push   $0x43
  jmp alltraps
80105b85:	e9 0c f9 ff ff       	jmp    80105496 <alltraps>

80105b8a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $68
80105b8c:	6a 44                	push   $0x44
  jmp alltraps
80105b8e:	e9 03 f9 ff ff       	jmp    80105496 <alltraps>

80105b93 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $69
80105b95:	6a 45                	push   $0x45
  jmp alltraps
80105b97:	e9 fa f8 ff ff       	jmp    80105496 <alltraps>

80105b9c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b9c:	6a 00                	push   $0x0
  pushl $70
80105b9e:	6a 46                	push   $0x46
  jmp alltraps
80105ba0:	e9 f1 f8 ff ff       	jmp    80105496 <alltraps>

80105ba5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $71
80105ba7:	6a 47                	push   $0x47
  jmp alltraps
80105ba9:	e9 e8 f8 ff ff       	jmp    80105496 <alltraps>

80105bae <vector72>:
.globl vector72
vector72:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $72
80105bb0:	6a 48                	push   $0x48
  jmp alltraps
80105bb2:	e9 df f8 ff ff       	jmp    80105496 <alltraps>

80105bb7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $73
80105bb9:	6a 49                	push   $0x49
  jmp alltraps
80105bbb:	e9 d6 f8 ff ff       	jmp    80105496 <alltraps>

80105bc0 <vector74>:
.globl vector74
vector74:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $74
80105bc2:	6a 4a                	push   $0x4a
  jmp alltraps
80105bc4:	e9 cd f8 ff ff       	jmp    80105496 <alltraps>

80105bc9 <vector75>:
.globl vector75
vector75:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $75
80105bcb:	6a 4b                	push   $0x4b
  jmp alltraps
80105bcd:	e9 c4 f8 ff ff       	jmp    80105496 <alltraps>

80105bd2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $76
80105bd4:	6a 4c                	push   $0x4c
  jmp alltraps
80105bd6:	e9 bb f8 ff ff       	jmp    80105496 <alltraps>

80105bdb <vector77>:
.globl vector77
vector77:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $77
80105bdd:	6a 4d                	push   $0x4d
  jmp alltraps
80105bdf:	e9 b2 f8 ff ff       	jmp    80105496 <alltraps>

80105be4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $78
80105be6:	6a 4e                	push   $0x4e
  jmp alltraps
80105be8:	e9 a9 f8 ff ff       	jmp    80105496 <alltraps>

80105bed <vector79>:
.globl vector79
vector79:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $79
80105bef:	6a 4f                	push   $0x4f
  jmp alltraps
80105bf1:	e9 a0 f8 ff ff       	jmp    80105496 <alltraps>

80105bf6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $80
80105bf8:	6a 50                	push   $0x50
  jmp alltraps
80105bfa:	e9 97 f8 ff ff       	jmp    80105496 <alltraps>

80105bff <vector81>:
.globl vector81
vector81:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $81
80105c01:	6a 51                	push   $0x51
  jmp alltraps
80105c03:	e9 8e f8 ff ff       	jmp    80105496 <alltraps>

80105c08 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $82
80105c0a:	6a 52                	push   $0x52
  jmp alltraps
80105c0c:	e9 85 f8 ff ff       	jmp    80105496 <alltraps>

80105c11 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $83
80105c13:	6a 53                	push   $0x53
  jmp alltraps
80105c15:	e9 7c f8 ff ff       	jmp    80105496 <alltraps>

80105c1a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $84
80105c1c:	6a 54                	push   $0x54
  jmp alltraps
80105c1e:	e9 73 f8 ff ff       	jmp    80105496 <alltraps>

80105c23 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $85
80105c25:	6a 55                	push   $0x55
  jmp alltraps
80105c27:	e9 6a f8 ff ff       	jmp    80105496 <alltraps>

80105c2c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c2c:	6a 00                	push   $0x0
  pushl $86
80105c2e:	6a 56                	push   $0x56
  jmp alltraps
80105c30:	e9 61 f8 ff ff       	jmp    80105496 <alltraps>

80105c35 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $87
80105c37:	6a 57                	push   $0x57
  jmp alltraps
80105c39:	e9 58 f8 ff ff       	jmp    80105496 <alltraps>

80105c3e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $88
80105c40:	6a 58                	push   $0x58
  jmp alltraps
80105c42:	e9 4f f8 ff ff       	jmp    80105496 <alltraps>

80105c47 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $89
80105c49:	6a 59                	push   $0x59
  jmp alltraps
80105c4b:	e9 46 f8 ff ff       	jmp    80105496 <alltraps>

80105c50 <vector90>:
.globl vector90
vector90:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $90
80105c52:	6a 5a                	push   $0x5a
  jmp alltraps
80105c54:	e9 3d f8 ff ff       	jmp    80105496 <alltraps>

80105c59 <vector91>:
.globl vector91
vector91:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $91
80105c5b:	6a 5b                	push   $0x5b
  jmp alltraps
80105c5d:	e9 34 f8 ff ff       	jmp    80105496 <alltraps>

80105c62 <vector92>:
.globl vector92
vector92:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $92
80105c64:	6a 5c                	push   $0x5c
  jmp alltraps
80105c66:	e9 2b f8 ff ff       	jmp    80105496 <alltraps>

80105c6b <vector93>:
.globl vector93
vector93:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $93
80105c6d:	6a 5d                	push   $0x5d
  jmp alltraps
80105c6f:	e9 22 f8 ff ff       	jmp    80105496 <alltraps>

80105c74 <vector94>:
.globl vector94
vector94:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $94
80105c76:	6a 5e                	push   $0x5e
  jmp alltraps
80105c78:	e9 19 f8 ff ff       	jmp    80105496 <alltraps>

80105c7d <vector95>:
.globl vector95
vector95:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $95
80105c7f:	6a 5f                	push   $0x5f
  jmp alltraps
80105c81:	e9 10 f8 ff ff       	jmp    80105496 <alltraps>

80105c86 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $96
80105c88:	6a 60                	push   $0x60
  jmp alltraps
80105c8a:	e9 07 f8 ff ff       	jmp    80105496 <alltraps>

80105c8f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $97
80105c91:	6a 61                	push   $0x61
  jmp alltraps
80105c93:	e9 fe f7 ff ff       	jmp    80105496 <alltraps>

80105c98 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $98
80105c9a:	6a 62                	push   $0x62
  jmp alltraps
80105c9c:	e9 f5 f7 ff ff       	jmp    80105496 <alltraps>

80105ca1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $99
80105ca3:	6a 63                	push   $0x63
  jmp alltraps
80105ca5:	e9 ec f7 ff ff       	jmp    80105496 <alltraps>

80105caa <vector100>:
.globl vector100
vector100:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $100
80105cac:	6a 64                	push   $0x64
  jmp alltraps
80105cae:	e9 e3 f7 ff ff       	jmp    80105496 <alltraps>

80105cb3 <vector101>:
.globl vector101
vector101:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $101
80105cb5:	6a 65                	push   $0x65
  jmp alltraps
80105cb7:	e9 da f7 ff ff       	jmp    80105496 <alltraps>

80105cbc <vector102>:
.globl vector102
vector102:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $102
80105cbe:	6a 66                	push   $0x66
  jmp alltraps
80105cc0:	e9 d1 f7 ff ff       	jmp    80105496 <alltraps>

80105cc5 <vector103>:
.globl vector103
vector103:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $103
80105cc7:	6a 67                	push   $0x67
  jmp alltraps
80105cc9:	e9 c8 f7 ff ff       	jmp    80105496 <alltraps>

80105cce <vector104>:
.globl vector104
vector104:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $104
80105cd0:	6a 68                	push   $0x68
  jmp alltraps
80105cd2:	e9 bf f7 ff ff       	jmp    80105496 <alltraps>

80105cd7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $105
80105cd9:	6a 69                	push   $0x69
  jmp alltraps
80105cdb:	e9 b6 f7 ff ff       	jmp    80105496 <alltraps>

80105ce0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $106
80105ce2:	6a 6a                	push   $0x6a
  jmp alltraps
80105ce4:	e9 ad f7 ff ff       	jmp    80105496 <alltraps>

80105ce9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $107
80105ceb:	6a 6b                	push   $0x6b
  jmp alltraps
80105ced:	e9 a4 f7 ff ff       	jmp    80105496 <alltraps>

80105cf2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $108
80105cf4:	6a 6c                	push   $0x6c
  jmp alltraps
80105cf6:	e9 9b f7 ff ff       	jmp    80105496 <alltraps>

80105cfb <vector109>:
.globl vector109
vector109:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $109
80105cfd:	6a 6d                	push   $0x6d
  jmp alltraps
80105cff:	e9 92 f7 ff ff       	jmp    80105496 <alltraps>

80105d04 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $110
80105d06:	6a 6e                	push   $0x6e
  jmp alltraps
80105d08:	e9 89 f7 ff ff       	jmp    80105496 <alltraps>

80105d0d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $111
80105d0f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d11:	e9 80 f7 ff ff       	jmp    80105496 <alltraps>

80105d16 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $112
80105d18:	6a 70                	push   $0x70
  jmp alltraps
80105d1a:	e9 77 f7 ff ff       	jmp    80105496 <alltraps>

80105d1f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $113
80105d21:	6a 71                	push   $0x71
  jmp alltraps
80105d23:	e9 6e f7 ff ff       	jmp    80105496 <alltraps>

80105d28 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $114
80105d2a:	6a 72                	push   $0x72
  jmp alltraps
80105d2c:	e9 65 f7 ff ff       	jmp    80105496 <alltraps>

80105d31 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $115
80105d33:	6a 73                	push   $0x73
  jmp alltraps
80105d35:	e9 5c f7 ff ff       	jmp    80105496 <alltraps>

80105d3a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $116
80105d3c:	6a 74                	push   $0x74
  jmp alltraps
80105d3e:	e9 53 f7 ff ff       	jmp    80105496 <alltraps>

80105d43 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $117
80105d45:	6a 75                	push   $0x75
  jmp alltraps
80105d47:	e9 4a f7 ff ff       	jmp    80105496 <alltraps>

80105d4c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $118
80105d4e:	6a 76                	push   $0x76
  jmp alltraps
80105d50:	e9 41 f7 ff ff       	jmp    80105496 <alltraps>

80105d55 <vector119>:
.globl vector119
vector119:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $119
80105d57:	6a 77                	push   $0x77
  jmp alltraps
80105d59:	e9 38 f7 ff ff       	jmp    80105496 <alltraps>

80105d5e <vector120>:
.globl vector120
vector120:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $120
80105d60:	6a 78                	push   $0x78
  jmp alltraps
80105d62:	e9 2f f7 ff ff       	jmp    80105496 <alltraps>

80105d67 <vector121>:
.globl vector121
vector121:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $121
80105d69:	6a 79                	push   $0x79
  jmp alltraps
80105d6b:	e9 26 f7 ff ff       	jmp    80105496 <alltraps>

80105d70 <vector122>:
.globl vector122
vector122:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $122
80105d72:	6a 7a                	push   $0x7a
  jmp alltraps
80105d74:	e9 1d f7 ff ff       	jmp    80105496 <alltraps>

80105d79 <vector123>:
.globl vector123
vector123:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $123
80105d7b:	6a 7b                	push   $0x7b
  jmp alltraps
80105d7d:	e9 14 f7 ff ff       	jmp    80105496 <alltraps>

80105d82 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $124
80105d84:	6a 7c                	push   $0x7c
  jmp alltraps
80105d86:	e9 0b f7 ff ff       	jmp    80105496 <alltraps>

80105d8b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $125
80105d8d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d8f:	e9 02 f7 ff ff       	jmp    80105496 <alltraps>

80105d94 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $126
80105d96:	6a 7e                	push   $0x7e
  jmp alltraps
80105d98:	e9 f9 f6 ff ff       	jmp    80105496 <alltraps>

80105d9d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $127
80105d9f:	6a 7f                	push   $0x7f
  jmp alltraps
80105da1:	e9 f0 f6 ff ff       	jmp    80105496 <alltraps>

80105da6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $128
80105da8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105dad:	e9 e4 f6 ff ff       	jmp    80105496 <alltraps>

80105db2 <vector129>:
.globl vector129
vector129:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $129
80105db4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105db9:	e9 d8 f6 ff ff       	jmp    80105496 <alltraps>

80105dbe <vector130>:
.globl vector130
vector130:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $130
80105dc0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105dc5:	e9 cc f6 ff ff       	jmp    80105496 <alltraps>

80105dca <vector131>:
.globl vector131
vector131:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $131
80105dcc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105dd1:	e9 c0 f6 ff ff       	jmp    80105496 <alltraps>

80105dd6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $132
80105dd8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ddd:	e9 b4 f6 ff ff       	jmp    80105496 <alltraps>

80105de2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $133
80105de4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105de9:	e9 a8 f6 ff ff       	jmp    80105496 <alltraps>

80105dee <vector134>:
.globl vector134
vector134:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $134
80105df0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105df5:	e9 9c f6 ff ff       	jmp    80105496 <alltraps>

80105dfa <vector135>:
.globl vector135
vector135:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $135
80105dfc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e01:	e9 90 f6 ff ff       	jmp    80105496 <alltraps>

80105e06 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $136
80105e08:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e0d:	e9 84 f6 ff ff       	jmp    80105496 <alltraps>

80105e12 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $137
80105e14:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e19:	e9 78 f6 ff ff       	jmp    80105496 <alltraps>

80105e1e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $138
80105e20:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e25:	e9 6c f6 ff ff       	jmp    80105496 <alltraps>

80105e2a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $139
80105e2c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e31:	e9 60 f6 ff ff       	jmp    80105496 <alltraps>

80105e36 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $140
80105e38:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e3d:	e9 54 f6 ff ff       	jmp    80105496 <alltraps>

80105e42 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $141
80105e44:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e49:	e9 48 f6 ff ff       	jmp    80105496 <alltraps>

80105e4e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $142
80105e50:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105e55:	e9 3c f6 ff ff       	jmp    80105496 <alltraps>

80105e5a <vector143>:
.globl vector143
vector143:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $143
80105e5c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105e61:	e9 30 f6 ff ff       	jmp    80105496 <alltraps>

80105e66 <vector144>:
.globl vector144
vector144:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $144
80105e68:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105e6d:	e9 24 f6 ff ff       	jmp    80105496 <alltraps>

80105e72 <vector145>:
.globl vector145
vector145:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $145
80105e74:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105e79:	e9 18 f6 ff ff       	jmp    80105496 <alltraps>

80105e7e <vector146>:
.globl vector146
vector146:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $146
80105e80:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e85:	e9 0c f6 ff ff       	jmp    80105496 <alltraps>

80105e8a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $147
80105e8c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e91:	e9 00 f6 ff ff       	jmp    80105496 <alltraps>

80105e96 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $148
80105e98:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e9d:	e9 f4 f5 ff ff       	jmp    80105496 <alltraps>

80105ea2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $149
80105ea4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ea9:	e9 e8 f5 ff ff       	jmp    80105496 <alltraps>

80105eae <vector150>:
.globl vector150
vector150:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $150
80105eb0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105eb5:	e9 dc f5 ff ff       	jmp    80105496 <alltraps>

80105eba <vector151>:
.globl vector151
vector151:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $151
80105ebc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105ec1:	e9 d0 f5 ff ff       	jmp    80105496 <alltraps>

80105ec6 <vector152>:
.globl vector152
vector152:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $152
80105ec8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ecd:	e9 c4 f5 ff ff       	jmp    80105496 <alltraps>

80105ed2 <vector153>:
.globl vector153
vector153:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $153
80105ed4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105ed9:	e9 b8 f5 ff ff       	jmp    80105496 <alltraps>

80105ede <vector154>:
.globl vector154
vector154:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $154
80105ee0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ee5:	e9 ac f5 ff ff       	jmp    80105496 <alltraps>

80105eea <vector155>:
.globl vector155
vector155:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $155
80105eec:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ef1:	e9 a0 f5 ff ff       	jmp    80105496 <alltraps>

80105ef6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $156
80105ef8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105efd:	e9 94 f5 ff ff       	jmp    80105496 <alltraps>

80105f02 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $157
80105f04:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f09:	e9 88 f5 ff ff       	jmp    80105496 <alltraps>

80105f0e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $158
80105f10:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f15:	e9 7c f5 ff ff       	jmp    80105496 <alltraps>

80105f1a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $159
80105f1c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f21:	e9 70 f5 ff ff       	jmp    80105496 <alltraps>

80105f26 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $160
80105f28:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f2d:	e9 64 f5 ff ff       	jmp    80105496 <alltraps>

80105f32 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $161
80105f34:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f39:	e9 58 f5 ff ff       	jmp    80105496 <alltraps>

80105f3e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $162
80105f40:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f45:	e9 4c f5 ff ff       	jmp    80105496 <alltraps>

80105f4a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $163
80105f4c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105f51:	e9 40 f5 ff ff       	jmp    80105496 <alltraps>

80105f56 <vector164>:
.globl vector164
vector164:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $164
80105f58:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105f5d:	e9 34 f5 ff ff       	jmp    80105496 <alltraps>

80105f62 <vector165>:
.globl vector165
vector165:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $165
80105f64:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105f69:	e9 28 f5 ff ff       	jmp    80105496 <alltraps>

80105f6e <vector166>:
.globl vector166
vector166:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $166
80105f70:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105f75:	e9 1c f5 ff ff       	jmp    80105496 <alltraps>

80105f7a <vector167>:
.globl vector167
vector167:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $167
80105f7c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f81:	e9 10 f5 ff ff       	jmp    80105496 <alltraps>

80105f86 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $168
80105f88:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f8d:	e9 04 f5 ff ff       	jmp    80105496 <alltraps>

80105f92 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $169
80105f94:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f99:	e9 f8 f4 ff ff       	jmp    80105496 <alltraps>

80105f9e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $170
80105fa0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105fa5:	e9 ec f4 ff ff       	jmp    80105496 <alltraps>

80105faa <vector171>:
.globl vector171
vector171:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $171
80105fac:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105fb1:	e9 e0 f4 ff ff       	jmp    80105496 <alltraps>

80105fb6 <vector172>:
.globl vector172
vector172:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $172
80105fb8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105fbd:	e9 d4 f4 ff ff       	jmp    80105496 <alltraps>

80105fc2 <vector173>:
.globl vector173
vector173:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $173
80105fc4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105fc9:	e9 c8 f4 ff ff       	jmp    80105496 <alltraps>

80105fce <vector174>:
.globl vector174
vector174:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $174
80105fd0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105fd5:	e9 bc f4 ff ff       	jmp    80105496 <alltraps>

80105fda <vector175>:
.globl vector175
vector175:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $175
80105fdc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105fe1:	e9 b0 f4 ff ff       	jmp    80105496 <alltraps>

80105fe6 <vector176>:
.globl vector176
vector176:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $176
80105fe8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105fed:	e9 a4 f4 ff ff       	jmp    80105496 <alltraps>

80105ff2 <vector177>:
.globl vector177
vector177:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $177
80105ff4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105ff9:	e9 98 f4 ff ff       	jmp    80105496 <alltraps>

80105ffe <vector178>:
.globl vector178
vector178:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $178
80106000:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106005:	e9 8c f4 ff ff       	jmp    80105496 <alltraps>

8010600a <vector179>:
.globl vector179
vector179:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $179
8010600c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106011:	e9 80 f4 ff ff       	jmp    80105496 <alltraps>

80106016 <vector180>:
.globl vector180
vector180:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $180
80106018:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010601d:	e9 74 f4 ff ff       	jmp    80105496 <alltraps>

80106022 <vector181>:
.globl vector181
vector181:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $181
80106024:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106029:	e9 68 f4 ff ff       	jmp    80105496 <alltraps>

8010602e <vector182>:
.globl vector182
vector182:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $182
80106030:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106035:	e9 5c f4 ff ff       	jmp    80105496 <alltraps>

8010603a <vector183>:
.globl vector183
vector183:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $183
8010603c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106041:	e9 50 f4 ff ff       	jmp    80105496 <alltraps>

80106046 <vector184>:
.globl vector184
vector184:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $184
80106048:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010604d:	e9 44 f4 ff ff       	jmp    80105496 <alltraps>

80106052 <vector185>:
.globl vector185
vector185:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $185
80106054:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106059:	e9 38 f4 ff ff       	jmp    80105496 <alltraps>

8010605e <vector186>:
.globl vector186
vector186:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $186
80106060:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106065:	e9 2c f4 ff ff       	jmp    80105496 <alltraps>

8010606a <vector187>:
.globl vector187
vector187:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $187
8010606c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106071:	e9 20 f4 ff ff       	jmp    80105496 <alltraps>

80106076 <vector188>:
.globl vector188
vector188:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $188
80106078:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010607d:	e9 14 f4 ff ff       	jmp    80105496 <alltraps>

80106082 <vector189>:
.globl vector189
vector189:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $189
80106084:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106089:	e9 08 f4 ff ff       	jmp    80105496 <alltraps>

8010608e <vector190>:
.globl vector190
vector190:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $190
80106090:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106095:	e9 fc f3 ff ff       	jmp    80105496 <alltraps>

8010609a <vector191>:
.globl vector191
vector191:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $191
8010609c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801060a1:	e9 f0 f3 ff ff       	jmp    80105496 <alltraps>

801060a6 <vector192>:
.globl vector192
vector192:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $192
801060a8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801060ad:	e9 e4 f3 ff ff       	jmp    80105496 <alltraps>

801060b2 <vector193>:
.globl vector193
vector193:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $193
801060b4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801060b9:	e9 d8 f3 ff ff       	jmp    80105496 <alltraps>

801060be <vector194>:
.globl vector194
vector194:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $194
801060c0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801060c5:	e9 cc f3 ff ff       	jmp    80105496 <alltraps>

801060ca <vector195>:
.globl vector195
vector195:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $195
801060cc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801060d1:	e9 c0 f3 ff ff       	jmp    80105496 <alltraps>

801060d6 <vector196>:
.globl vector196
vector196:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $196
801060d8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801060dd:	e9 b4 f3 ff ff       	jmp    80105496 <alltraps>

801060e2 <vector197>:
.globl vector197
vector197:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $197
801060e4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801060e9:	e9 a8 f3 ff ff       	jmp    80105496 <alltraps>

801060ee <vector198>:
.globl vector198
vector198:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $198
801060f0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801060f5:	e9 9c f3 ff ff       	jmp    80105496 <alltraps>

801060fa <vector199>:
.globl vector199
vector199:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $199
801060fc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106101:	e9 90 f3 ff ff       	jmp    80105496 <alltraps>

80106106 <vector200>:
.globl vector200
vector200:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $200
80106108:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010610d:	e9 84 f3 ff ff       	jmp    80105496 <alltraps>

80106112 <vector201>:
.globl vector201
vector201:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $201
80106114:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106119:	e9 78 f3 ff ff       	jmp    80105496 <alltraps>

8010611e <vector202>:
.globl vector202
vector202:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $202
80106120:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106125:	e9 6c f3 ff ff       	jmp    80105496 <alltraps>

8010612a <vector203>:
.globl vector203
vector203:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $203
8010612c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106131:	e9 60 f3 ff ff       	jmp    80105496 <alltraps>

80106136 <vector204>:
.globl vector204
vector204:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $204
80106138:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010613d:	e9 54 f3 ff ff       	jmp    80105496 <alltraps>

80106142 <vector205>:
.globl vector205
vector205:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $205
80106144:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106149:	e9 48 f3 ff ff       	jmp    80105496 <alltraps>

8010614e <vector206>:
.globl vector206
vector206:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $206
80106150:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106155:	e9 3c f3 ff ff       	jmp    80105496 <alltraps>

8010615a <vector207>:
.globl vector207
vector207:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $207
8010615c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106161:	e9 30 f3 ff ff       	jmp    80105496 <alltraps>

80106166 <vector208>:
.globl vector208
vector208:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $208
80106168:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010616d:	e9 24 f3 ff ff       	jmp    80105496 <alltraps>

80106172 <vector209>:
.globl vector209
vector209:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $209
80106174:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106179:	e9 18 f3 ff ff       	jmp    80105496 <alltraps>

8010617e <vector210>:
.globl vector210
vector210:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $210
80106180:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106185:	e9 0c f3 ff ff       	jmp    80105496 <alltraps>

8010618a <vector211>:
.globl vector211
vector211:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $211
8010618c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106191:	e9 00 f3 ff ff       	jmp    80105496 <alltraps>

80106196 <vector212>:
.globl vector212
vector212:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $212
80106198:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010619d:	e9 f4 f2 ff ff       	jmp    80105496 <alltraps>

801061a2 <vector213>:
.globl vector213
vector213:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $213
801061a4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801061a9:	e9 e8 f2 ff ff       	jmp    80105496 <alltraps>

801061ae <vector214>:
.globl vector214
vector214:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $214
801061b0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801061b5:	e9 dc f2 ff ff       	jmp    80105496 <alltraps>

801061ba <vector215>:
.globl vector215
vector215:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $215
801061bc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801061c1:	e9 d0 f2 ff ff       	jmp    80105496 <alltraps>

801061c6 <vector216>:
.globl vector216
vector216:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $216
801061c8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801061cd:	e9 c4 f2 ff ff       	jmp    80105496 <alltraps>

801061d2 <vector217>:
.globl vector217
vector217:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $217
801061d4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801061d9:	e9 b8 f2 ff ff       	jmp    80105496 <alltraps>

801061de <vector218>:
.globl vector218
vector218:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $218
801061e0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801061e5:	e9 ac f2 ff ff       	jmp    80105496 <alltraps>

801061ea <vector219>:
.globl vector219
vector219:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $219
801061ec:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801061f1:	e9 a0 f2 ff ff       	jmp    80105496 <alltraps>

801061f6 <vector220>:
.globl vector220
vector220:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $220
801061f8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801061fd:	e9 94 f2 ff ff       	jmp    80105496 <alltraps>

80106202 <vector221>:
.globl vector221
vector221:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $221
80106204:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106209:	e9 88 f2 ff ff       	jmp    80105496 <alltraps>

8010620e <vector222>:
.globl vector222
vector222:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $222
80106210:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106215:	e9 7c f2 ff ff       	jmp    80105496 <alltraps>

8010621a <vector223>:
.globl vector223
vector223:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $223
8010621c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106221:	e9 70 f2 ff ff       	jmp    80105496 <alltraps>

80106226 <vector224>:
.globl vector224
vector224:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $224
80106228:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010622d:	e9 64 f2 ff ff       	jmp    80105496 <alltraps>

80106232 <vector225>:
.globl vector225
vector225:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $225
80106234:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106239:	e9 58 f2 ff ff       	jmp    80105496 <alltraps>

8010623e <vector226>:
.globl vector226
vector226:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $226
80106240:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106245:	e9 4c f2 ff ff       	jmp    80105496 <alltraps>

8010624a <vector227>:
.globl vector227
vector227:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $227
8010624c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106251:	e9 40 f2 ff ff       	jmp    80105496 <alltraps>

80106256 <vector228>:
.globl vector228
vector228:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $228
80106258:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010625d:	e9 34 f2 ff ff       	jmp    80105496 <alltraps>

80106262 <vector229>:
.globl vector229
vector229:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $229
80106264:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106269:	e9 28 f2 ff ff       	jmp    80105496 <alltraps>

8010626e <vector230>:
.globl vector230
vector230:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $230
80106270:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106275:	e9 1c f2 ff ff       	jmp    80105496 <alltraps>

8010627a <vector231>:
.globl vector231
vector231:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $231
8010627c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106281:	e9 10 f2 ff ff       	jmp    80105496 <alltraps>

80106286 <vector232>:
.globl vector232
vector232:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $232
80106288:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010628d:	e9 04 f2 ff ff       	jmp    80105496 <alltraps>

80106292 <vector233>:
.globl vector233
vector233:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $233
80106294:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106299:	e9 f8 f1 ff ff       	jmp    80105496 <alltraps>

8010629e <vector234>:
.globl vector234
vector234:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $234
801062a0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801062a5:	e9 ec f1 ff ff       	jmp    80105496 <alltraps>

801062aa <vector235>:
.globl vector235
vector235:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $235
801062ac:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801062b1:	e9 e0 f1 ff ff       	jmp    80105496 <alltraps>

801062b6 <vector236>:
.globl vector236
vector236:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $236
801062b8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801062bd:	e9 d4 f1 ff ff       	jmp    80105496 <alltraps>

801062c2 <vector237>:
.globl vector237
vector237:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $237
801062c4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801062c9:	e9 c8 f1 ff ff       	jmp    80105496 <alltraps>

801062ce <vector238>:
.globl vector238
vector238:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $238
801062d0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801062d5:	e9 bc f1 ff ff       	jmp    80105496 <alltraps>

801062da <vector239>:
.globl vector239
vector239:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $239
801062dc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801062e1:	e9 b0 f1 ff ff       	jmp    80105496 <alltraps>

801062e6 <vector240>:
.globl vector240
vector240:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $240
801062e8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801062ed:	e9 a4 f1 ff ff       	jmp    80105496 <alltraps>

801062f2 <vector241>:
.globl vector241
vector241:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $241
801062f4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801062f9:	e9 98 f1 ff ff       	jmp    80105496 <alltraps>

801062fe <vector242>:
.globl vector242
vector242:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $242
80106300:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106305:	e9 8c f1 ff ff       	jmp    80105496 <alltraps>

8010630a <vector243>:
.globl vector243
vector243:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $243
8010630c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106311:	e9 80 f1 ff ff       	jmp    80105496 <alltraps>

80106316 <vector244>:
.globl vector244
vector244:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $244
80106318:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010631d:	e9 74 f1 ff ff       	jmp    80105496 <alltraps>

80106322 <vector245>:
.globl vector245
vector245:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $245
80106324:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106329:	e9 68 f1 ff ff       	jmp    80105496 <alltraps>

8010632e <vector246>:
.globl vector246
vector246:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $246
80106330:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106335:	e9 5c f1 ff ff       	jmp    80105496 <alltraps>

8010633a <vector247>:
.globl vector247
vector247:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $247
8010633c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106341:	e9 50 f1 ff ff       	jmp    80105496 <alltraps>

80106346 <vector248>:
.globl vector248
vector248:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $248
80106348:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010634d:	e9 44 f1 ff ff       	jmp    80105496 <alltraps>

80106352 <vector249>:
.globl vector249
vector249:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $249
80106354:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106359:	e9 38 f1 ff ff       	jmp    80105496 <alltraps>

8010635e <vector250>:
.globl vector250
vector250:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $250
80106360:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106365:	e9 2c f1 ff ff       	jmp    80105496 <alltraps>

8010636a <vector251>:
.globl vector251
vector251:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $251
8010636c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106371:	e9 20 f1 ff ff       	jmp    80105496 <alltraps>

80106376 <vector252>:
.globl vector252
vector252:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $252
80106378:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010637d:	e9 14 f1 ff ff       	jmp    80105496 <alltraps>

80106382 <vector253>:
.globl vector253
vector253:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $253
80106384:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106389:	e9 08 f1 ff ff       	jmp    80105496 <alltraps>

8010638e <vector254>:
.globl vector254
vector254:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $254
80106390:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106395:	e9 fc f0 ff ff       	jmp    80105496 <alltraps>

8010639a <vector255>:
.globl vector255
vector255:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $255
8010639c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801063a1:	e9 f0 f0 ff ff       	jmp    80105496 <alltraps>
801063a6:	66 90                	xchg   %ax,%ax
801063a8:	66 90                	xchg   %ax,%ax
801063aa:	66 90                	xchg   %ax,%ax
801063ac:	66 90                	xchg   %ax,%ax
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	56                   	push   %esi
801063b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801063b7:	c1 ea 16             	shr    $0x16,%edx
{
801063ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801063bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801063be:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
801063c1:	8b 1f                	mov    (%edi),%ebx
801063c3:	f6 c3 01             	test   $0x1,%bl
801063c6:	74 28                	je     801063f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801063c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801063ce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801063d4:	c1 ee 0a             	shr    $0xa,%esi
}
801063d7:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
801063da:	89 f2                	mov    %esi,%edx
801063dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801063e5:	5b                   	pop    %ebx
801063e6:	5e                   	pop    %esi
801063e7:	5f                   	pop    %edi
801063e8:	5d                   	pop    %ebp
801063e9:	c3                   	ret    
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063f0:	85 c9                	test   %ecx,%ecx
801063f2:	74 34                	je     80106428 <walkpgdir+0x78>
801063f4:	e8 a7 c0 ff ff       	call   801024a0 <kalloc>
801063f9:	85 c0                	test   %eax,%eax
801063fb:	89 c3                	mov    %eax,%ebx
801063fd:	74 29                	je     80106428 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801063ff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106406:	00 
80106407:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010640e:	00 
8010640f:	89 04 24             	mov    %eax,(%esp)
80106412:	e8 39 df ff ff       	call   80104350 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106417:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010641d:	83 c8 07             	or     $0x7,%eax
80106420:	89 07                	mov    %eax,(%edi)
80106422:	eb b0                	jmp    801063d4 <walkpgdir+0x24>
80106424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106428:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010642b:	31 c0                	xor    %eax,%eax
}
8010642d:	5b                   	pop    %ebx
8010642e:	5e                   	pop    %esi
8010642f:	5f                   	pop    %edi
80106430:	5d                   	pop    %ebp
80106431:	c3                   	ret    
80106432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106440 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	57                   	push   %edi
80106444:	56                   	push   %esi
80106445:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106446:	89 d3                	mov    %edx,%ebx
{
80106448:	83 ec 1c             	sub    $0x1c,%esp
8010644b:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
8010644e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106454:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106457:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010645b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010645e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106462:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106469:	29 df                	sub    %ebx,%edi
8010646b:	eb 18                	jmp    80106485 <mappages+0x45>
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80106470:	f6 00 01             	testb  $0x1,(%eax)
80106473:	75 3d                	jne    801064b2 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106475:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106478:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010647b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010647d:	74 29                	je     801064a8 <mappages+0x68>
      break;
    a += PGSIZE;
8010647f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106485:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106488:	b9 01 00 00 00       	mov    $0x1,%ecx
8010648d:	89 da                	mov    %ebx,%edx
8010648f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106492:	e8 19 ff ff ff       	call   801063b0 <walkpgdir>
80106497:	85 c0                	test   %eax,%eax
80106499:	75 d5                	jne    80106470 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010649b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010649e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064a3:	5b                   	pop    %ebx
801064a4:	5e                   	pop    %esi
801064a5:	5f                   	pop    %edi
801064a6:	5d                   	pop    %ebp
801064a7:	c3                   	ret    
801064a8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801064ab:	31 c0                	xor    %eax,%eax
}
801064ad:	5b                   	pop    %ebx
801064ae:	5e                   	pop    %esi
801064af:	5f                   	pop    %edi
801064b0:	5d                   	pop    %ebp
801064b1:	c3                   	ret    
      panic("remap");
801064b2:	c7 04 24 8c 75 10 80 	movl   $0x8010758c,(%esp)
801064b9:	e8 a2 9e ff ff       	call   80100360 <panic>
801064be:	66 90                	xchg   %ax,%ax

801064c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	57                   	push   %edi
801064c4:	89 c7                	mov    %eax,%edi
801064c6:	56                   	push   %esi
801064c7:	89 d6                	mov    %edx,%esi
801064c9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801064ca:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064d0:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
801064d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801064d9:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801064de:	72 3b                	jb     8010651b <deallocuvm.part.0+0x5b>
801064e0:	eb 5e                	jmp    80106540 <deallocuvm.part.0+0x80>
801064e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801064e8:	8b 10                	mov    (%eax),%edx
801064ea:	f6 c2 01             	test   $0x1,%dl
801064ed:	74 22                	je     80106511 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801064ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801064f5:	74 54                	je     8010654b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801064f7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801064fd:	89 14 24             	mov    %edx,(%esp)
80106500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106503:	e8 e8 bd ff ff       	call   801022f0 <kfree>
      *pte = 0;
80106508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010650b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106511:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106517:	39 f3                	cmp    %esi,%ebx
80106519:	73 25                	jae    80106540 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010651b:	31 c9                	xor    %ecx,%ecx
8010651d:	89 da                	mov    %ebx,%edx
8010651f:	89 f8                	mov    %edi,%eax
80106521:	e8 8a fe ff ff       	call   801063b0 <walkpgdir>
    if(!pte)
80106526:	85 c0                	test   %eax,%eax
80106528:	75 be                	jne    801064e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010652a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106530:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106536:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010653c:	39 f3                	cmp    %esi,%ebx
8010653e:	72 db                	jb     8010651b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106540:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106543:	83 c4 1c             	add    $0x1c,%esp
80106546:	5b                   	pop    %ebx
80106547:	5e                   	pop    %esi
80106548:	5f                   	pop    %edi
80106549:	5d                   	pop    %ebp
8010654a:	c3                   	ret    
        panic("kfree");
8010654b:	c7 04 24 26 6f 10 80 	movl   $0x80106f26,(%esp)
80106552:	e8 09 9e ff ff       	call   80100360 <panic>
80106557:	89 f6                	mov    %esi,%esi
80106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106560 <seginit>:
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106566:	e8 65 d1 ff ff       	call   801036d0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010656b:	31 c9                	xor    %ecx,%ecx
8010656d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106572:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106578:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010657d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106581:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106586:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106589:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010658d:	31 c9                	xor    %ecx,%ecx
8010658f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106593:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106598:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010659c:	31 c9                	xor    %ecx,%ecx
8010659e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065a2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065a7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065ab:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065ad:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801065b1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065b5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801065b9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065bd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801065c1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065c5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801065c9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801065cd:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
801065d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065d6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801065da:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065de:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801065e2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065e6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801065ea:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065ee:	66 89 48 22          	mov    %cx,0x22(%eax)
801065f2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801065f6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801065fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801065fe:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106602:	c1 e8 10             	shr    $0x10,%eax
80106605:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106609:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010660c:	0f 01 10             	lgdtl  (%eax)
}
8010660f:	c9                   	leave  
80106610:	c3                   	ret    
80106611:	eb 0d                	jmp    80106620 <switchkvm>
80106613:	90                   	nop
80106614:	90                   	nop
80106615:	90                   	nop
80106616:	90                   	nop
80106617:	90                   	nop
80106618:	90                   	nop
80106619:	90                   	nop
8010661a:	90                   	nop
8010661b:	90                   	nop
8010661c:	90                   	nop
8010661d:	90                   	nop
8010661e:	90                   	nop
8010661f:	90                   	nop

80106620 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106620:	a1 c4 54 11 80       	mov    0x801154c4,%eax
{
80106625:	55                   	push   %ebp
80106626:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106628:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010662d:	0f 22 d8             	mov    %eax,%cr3
}
80106630:	5d                   	pop    %ebp
80106631:	c3                   	ret    
80106632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106640 <switchuvm>:
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	57                   	push   %edi
80106644:	56                   	push   %esi
80106645:	53                   	push   %ebx
80106646:	83 ec 1c             	sub    $0x1c,%esp
80106649:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010664c:	85 f6                	test   %esi,%esi
8010664e:	0f 84 cd 00 00 00    	je     80106721 <switchuvm+0xe1>
  if(p->kstack == 0)
80106654:	8b 46 08             	mov    0x8(%esi),%eax
80106657:	85 c0                	test   %eax,%eax
80106659:	0f 84 da 00 00 00    	je     80106739 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010665f:	8b 7e 04             	mov    0x4(%esi),%edi
80106662:	85 ff                	test   %edi,%edi
80106664:	0f 84 c3 00 00 00    	je     8010672d <switchuvm+0xed>
  pushcli();
8010666a:	e8 31 db ff ff       	call   801041a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010666f:	e8 dc cf ff ff       	call   80103650 <mycpu>
80106674:	89 c3                	mov    %eax,%ebx
80106676:	e8 d5 cf ff ff       	call   80103650 <mycpu>
8010667b:	89 c7                	mov    %eax,%edi
8010667d:	e8 ce cf ff ff       	call   80103650 <mycpu>
80106682:	83 c7 08             	add    $0x8,%edi
80106685:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106688:	e8 c3 cf ff ff       	call   80103650 <mycpu>
8010668d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106690:	ba 67 00 00 00       	mov    $0x67,%edx
80106695:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010669c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801066a3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801066aa:	83 c1 08             	add    $0x8,%ecx
801066ad:	c1 e9 10             	shr    $0x10,%ecx
801066b0:	83 c0 08             	add    $0x8,%eax
801066b3:	c1 e8 18             	shr    $0x18,%eax
801066b6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801066bc:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801066c3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066c9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801066ce:	e8 7d cf ff ff       	call   80103650 <mycpu>
801066d3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801066da:	e8 71 cf ff ff       	call   80103650 <mycpu>
801066df:	b9 10 00 00 00       	mov    $0x10,%ecx
801066e4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066e8:	e8 63 cf ff ff       	call   80103650 <mycpu>
801066ed:	8b 56 08             	mov    0x8(%esi),%edx
801066f0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801066f6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066f9:	e8 52 cf ff ff       	call   80103650 <mycpu>
801066fe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106702:	b8 28 00 00 00       	mov    $0x28,%eax
80106707:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010670a:	8b 46 04             	mov    0x4(%esi),%eax
8010670d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106712:	0f 22 d8             	mov    %eax,%cr3
}
80106715:	83 c4 1c             	add    $0x1c,%esp
80106718:	5b                   	pop    %ebx
80106719:	5e                   	pop    %esi
8010671a:	5f                   	pop    %edi
8010671b:	5d                   	pop    %ebp
  popcli();
8010671c:	e9 bf da ff ff       	jmp    801041e0 <popcli>
    panic("switchuvm: no process");
80106721:	c7 04 24 92 75 10 80 	movl   $0x80107592,(%esp)
80106728:	e8 33 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010672d:	c7 04 24 bd 75 10 80 	movl   $0x801075bd,(%esp)
80106734:	e8 27 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106739:	c7 04 24 a8 75 10 80 	movl   $0x801075a8,(%esp)
80106740:	e8 1b 9c ff ff       	call   80100360 <panic>
80106745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106750 <inituvm>:
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	83 ec 1c             	sub    $0x1c,%esp
80106759:	8b 75 10             	mov    0x10(%ebp),%esi
8010675c:	8b 45 08             	mov    0x8(%ebp),%eax
8010675f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106762:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010676b:	77 54                	ja     801067c1 <inituvm+0x71>
  mem = kalloc();
8010676d:	e8 2e bd ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106772:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106779:	00 
8010677a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106781:	00 
  mem = kalloc();
80106782:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106784:	89 04 24             	mov    %eax,(%esp)
80106787:	e8 c4 db ff ff       	call   80104350 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010678c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106792:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106797:	89 04 24             	mov    %eax,(%esp)
8010679a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010679d:	31 d2                	xor    %edx,%edx
8010679f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801067a6:	00 
801067a7:	e8 94 fc ff ff       	call   80106440 <mappages>
  memmove(mem, init, sz);
801067ac:	89 75 10             	mov    %esi,0x10(%ebp)
801067af:	89 7d 0c             	mov    %edi,0xc(%ebp)
801067b2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801067b5:	83 c4 1c             	add    $0x1c,%esp
801067b8:	5b                   	pop    %ebx
801067b9:	5e                   	pop    %esi
801067ba:	5f                   	pop    %edi
801067bb:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801067bc:	e9 2f dc ff ff       	jmp    801043f0 <memmove>
    panic("inituvm: more than a page");
801067c1:	c7 04 24 d1 75 10 80 	movl   $0x801075d1,(%esp)
801067c8:	e8 93 9b ff ff       	call   80100360 <panic>
801067cd:	8d 76 00             	lea    0x0(%esi),%esi

801067d0 <loaduvm>:
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	56                   	push   %esi
801067d5:	53                   	push   %ebx
801067d6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
801067d9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067e0:	0f 85 98 00 00 00    	jne    8010687e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
801067e6:	8b 75 18             	mov    0x18(%ebp),%esi
801067e9:	31 db                	xor    %ebx,%ebx
801067eb:	85 f6                	test   %esi,%esi
801067ed:	75 1a                	jne    80106809 <loaduvm+0x39>
801067ef:	eb 77                	jmp    80106868 <loaduvm+0x98>
801067f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067fe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106804:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106807:	76 5f                	jbe    80106868 <loaduvm+0x98>
80106809:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010680c:	31 c9                	xor    %ecx,%ecx
8010680e:	8b 45 08             	mov    0x8(%ebp),%eax
80106811:	01 da                	add    %ebx,%edx
80106813:	e8 98 fb ff ff       	call   801063b0 <walkpgdir>
80106818:	85 c0                	test   %eax,%eax
8010681a:	74 56                	je     80106872 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010681c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010681e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106823:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106826:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010682b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106831:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106834:	05 00 00 00 80       	add    $0x80000000,%eax
80106839:	89 44 24 04          	mov    %eax,0x4(%esp)
8010683d:	8b 45 10             	mov    0x10(%ebp),%eax
80106840:	01 d9                	add    %ebx,%ecx
80106842:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106846:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010684a:	89 04 24             	mov    %eax,(%esp)
8010684d:	e8 0e b1 ff ff       	call   80101960 <readi>
80106852:	39 f8                	cmp    %edi,%eax
80106854:	74 a2                	je     801067f8 <loaduvm+0x28>
}
80106856:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106859:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010685e:	5b                   	pop    %ebx
8010685f:	5e                   	pop    %esi
80106860:	5f                   	pop    %edi
80106861:	5d                   	pop    %ebp
80106862:	c3                   	ret    
80106863:	90                   	nop
80106864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106868:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010686b:	31 c0                	xor    %eax,%eax
}
8010686d:	5b                   	pop    %ebx
8010686e:	5e                   	pop    %esi
8010686f:	5f                   	pop    %edi
80106870:	5d                   	pop    %ebp
80106871:	c3                   	ret    
      panic("loaduvm: address should exist");
80106872:	c7 04 24 eb 75 10 80 	movl   $0x801075eb,(%esp)
80106879:	e8 e2 9a ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010687e:	c7 04 24 8c 76 10 80 	movl   $0x8010768c,(%esp)
80106885:	e8 d6 9a ff ff       	call   80100360 <panic>
8010688a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106890 <allocuvm>:
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	83 ec 1c             	sub    $0x1c,%esp
80106899:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010689c:	85 ff                	test   %edi,%edi
8010689e:	0f 88 7e 00 00 00    	js     80106922 <allocuvm+0x92>
  if(newsz < oldsz)
801068a4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801068a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801068aa:	72 78                	jb     80106924 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
801068ac:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801068b2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801068b8:	39 df                	cmp    %ebx,%edi
801068ba:	77 4a                	ja     80106906 <allocuvm+0x76>
801068bc:	eb 72                	jmp    80106930 <allocuvm+0xa0>
801068be:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
801068c0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068c7:	00 
801068c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068cf:	00 
801068d0:	89 04 24             	mov    %eax,(%esp)
801068d3:	e8 78 da ff ff       	call   80104350 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801068d8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801068de:	b9 00 10 00 00       	mov    $0x1000,%ecx
801068e3:	89 04 24             	mov    %eax,(%esp)
801068e6:	8b 45 08             	mov    0x8(%ebp),%eax
801068e9:	89 da                	mov    %ebx,%edx
801068eb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801068f2:	00 
801068f3:	e8 48 fb ff ff       	call   80106440 <mappages>
801068f8:	85 c0                	test   %eax,%eax
801068fa:	78 44                	js     80106940 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
801068fc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106902:	39 df                	cmp    %ebx,%edi
80106904:	76 2a                	jbe    80106930 <allocuvm+0xa0>
    mem = kalloc();
80106906:	e8 95 bb ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
8010690b:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010690d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010690f:	75 af                	jne    801068c0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106911:	c7 04 24 09 76 10 80 	movl   $0x80107609,(%esp)
80106918:	e8 33 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010691d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106920:	77 48                	ja     8010696a <allocuvm+0xda>
      return 0;
80106922:	31 c0                	xor    %eax,%eax
}
80106924:	83 c4 1c             	add    $0x1c,%esp
80106927:	5b                   	pop    %ebx
80106928:	5e                   	pop    %esi
80106929:	5f                   	pop    %edi
8010692a:	5d                   	pop    %ebp
8010692b:	c3                   	ret    
8010692c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106930:	83 c4 1c             	add    $0x1c,%esp
80106933:	89 f8                	mov    %edi,%eax
80106935:	5b                   	pop    %ebx
80106936:	5e                   	pop    %esi
80106937:	5f                   	pop    %edi
80106938:	5d                   	pop    %ebp
80106939:	c3                   	ret    
8010693a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106940:	c7 04 24 21 76 10 80 	movl   $0x80107621,(%esp)
80106947:	e8 04 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010694c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010694f:	76 0d                	jbe    8010695e <allocuvm+0xce>
80106951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106954:	89 fa                	mov    %edi,%edx
80106956:	8b 45 08             	mov    0x8(%ebp),%eax
80106959:	e8 62 fb ff ff       	call   801064c0 <deallocuvm.part.0>
      kfree(mem);
8010695e:	89 34 24             	mov    %esi,(%esp)
80106961:	e8 8a b9 ff ff       	call   801022f0 <kfree>
      return 0;
80106966:	31 c0                	xor    %eax,%eax
80106968:	eb ba                	jmp    80106924 <allocuvm+0x94>
8010696a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010696d:	89 fa                	mov    %edi,%edx
8010696f:	8b 45 08             	mov    0x8(%ebp),%eax
80106972:	e8 49 fb ff ff       	call   801064c0 <deallocuvm.part.0>
      return 0;
80106977:	31 c0                	xor    %eax,%eax
80106979:	eb a9                	jmp    80106924 <allocuvm+0x94>
8010697b:	90                   	nop
8010697c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106980 <deallocuvm>:
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	8b 55 0c             	mov    0xc(%ebp),%edx
80106986:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106989:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010698c:	39 d1                	cmp    %edx,%ecx
8010698e:	73 08                	jae    80106998 <deallocuvm+0x18>
}
80106990:	5d                   	pop    %ebp
80106991:	e9 2a fb ff ff       	jmp    801064c0 <deallocuvm.part.0>
80106996:	66 90                	xchg   %ax,%ax
80106998:	89 d0                	mov    %edx,%eax
8010699a:	5d                   	pop    %ebp
8010699b:	c3                   	ret    
8010699c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	56                   	push   %esi
801069a4:	53                   	push   %ebx
801069a5:	83 ec 10             	sub    $0x10,%esp
801069a8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801069ab:	85 f6                	test   %esi,%esi
801069ad:	74 59                	je     80106a08 <freevm+0x68>
801069af:	31 c9                	xor    %ecx,%ecx
801069b1:	ba 00 00 00 80       	mov    $0x80000000,%edx
801069b6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801069b8:	31 db                	xor    %ebx,%ebx
801069ba:	e8 01 fb ff ff       	call   801064c0 <deallocuvm.part.0>
801069bf:	eb 12                	jmp    801069d3 <freevm+0x33>
801069c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c8:	83 c3 01             	add    $0x1,%ebx
801069cb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069d1:	74 27                	je     801069fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801069d3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801069d6:	f6 c2 01             	test   $0x1,%dl
801069d9:	74 ed                	je     801069c8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069db:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
801069e1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069e4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801069ea:	89 14 24             	mov    %edx,(%esp)
801069ed:	e8 fe b8 ff ff       	call   801022f0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801069f2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069f8:	75 d9                	jne    801069d3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801069fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801069fd:	83 c4 10             	add    $0x10,%esp
80106a00:	5b                   	pop    %ebx
80106a01:	5e                   	pop    %esi
80106a02:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106a03:	e9 e8 b8 ff ff       	jmp    801022f0 <kfree>
    panic("freevm: no pgdir");
80106a08:	c7 04 24 3d 76 10 80 	movl   $0x8010763d,(%esp)
80106a0f:	e8 4c 99 ff ff       	call   80100360 <panic>
80106a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a20 <setupkvm>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	56                   	push   %esi
80106a24:	53                   	push   %ebx
80106a25:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106a28:	e8 73 ba ff ff       	call   801024a0 <kalloc>
80106a2d:	85 c0                	test   %eax,%eax
80106a2f:	89 c6                	mov    %eax,%esi
80106a31:	74 6d                	je     80106aa0 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106a33:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a3a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a3b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106a40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a47:	00 
80106a48:	89 04 24             	mov    %eax,(%esp)
80106a4b:	e8 00 d9 ff ff       	call   80104350 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a50:	8b 53 0c             	mov    0xc(%ebx),%edx
80106a53:	8b 43 04             	mov    0x4(%ebx),%eax
80106a56:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106a59:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a5d:	8b 13                	mov    (%ebx),%edx
80106a5f:	89 04 24             	mov    %eax,(%esp)
80106a62:	29 c1                	sub    %eax,%ecx
80106a64:	89 f0                	mov    %esi,%eax
80106a66:	e8 d5 f9 ff ff       	call   80106440 <mappages>
80106a6b:	85 c0                	test   %eax,%eax
80106a6d:	78 19                	js     80106a88 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a6f:	83 c3 10             	add    $0x10,%ebx
80106a72:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a78:	72 d6                	jb     80106a50 <setupkvm+0x30>
80106a7a:	89 f0                	mov    %esi,%eax
}
80106a7c:	83 c4 10             	add    $0x10,%esp
80106a7f:	5b                   	pop    %ebx
80106a80:	5e                   	pop    %esi
80106a81:	5d                   	pop    %ebp
80106a82:	c3                   	ret    
80106a83:	90                   	nop
80106a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106a88:	89 34 24             	mov    %esi,(%esp)
80106a8b:	e8 10 ff ff ff       	call   801069a0 <freevm>
}
80106a90:	83 c4 10             	add    $0x10,%esp
      return 0;
80106a93:	31 c0                	xor    %eax,%eax
}
80106a95:	5b                   	pop    %ebx
80106a96:	5e                   	pop    %esi
80106a97:	5d                   	pop    %ebp
80106a98:	c3                   	ret    
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106aa0:	31 c0                	xor    %eax,%eax
80106aa2:	eb d8                	jmp    80106a7c <setupkvm+0x5c>
80106aa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106aaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ab0 <kvmalloc>:
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ab6:	e8 65 ff ff ff       	call   80106a20 <setupkvm>
80106abb:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ac0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ac5:	0f 22 d8             	mov    %eax,%cr3
}
80106ac8:	c9                   	leave  
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ad0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ad1:	31 c9                	xor    %ecx,%ecx
{
80106ad3:	89 e5                	mov    %esp,%ebp
80106ad5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106adb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ade:	e8 cd f8 ff ff       	call   801063b0 <walkpgdir>
  if(pte == 0)
80106ae3:	85 c0                	test   %eax,%eax
80106ae5:	74 05                	je     80106aec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ae7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106aea:	c9                   	leave  
80106aeb:	c3                   	ret    
    panic("clearpteu");
80106aec:	c7 04 24 4e 76 10 80 	movl   $0x8010764e,(%esp)
80106af3:	e8 68 98 ff ff       	call   80100360 <panic>
80106af8:	90                   	nop
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b09:	e8 12 ff ff ff       	call   80106a20 <setupkvm>
80106b0e:	85 c0                	test   %eax,%eax
80106b10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b13:	0f 84 b9 00 00 00    	je     80106bd2 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b19:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b1c:	85 c0                	test   %eax,%eax
80106b1e:	0f 84 94 00 00 00    	je     80106bb8 <copyuvm+0xb8>
80106b24:	31 ff                	xor    %edi,%edi
80106b26:	eb 48                	jmp    80106b70 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b28:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106b2e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b35:	00 
80106b36:	89 74 24 04          	mov    %esi,0x4(%esp)
80106b3a:	89 04 24             	mov    %eax,(%esp)
80106b3d:	e8 ae d8 ff ff       	call   801043f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b45:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b4a:	89 fa                	mov    %edi,%edx
80106b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b50:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b56:	89 04 24             	mov    %eax,(%esp)
80106b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b5c:	e8 df f8 ff ff       	call   80106440 <mappages>
80106b61:	85 c0                	test   %eax,%eax
80106b63:	78 63                	js     80106bc8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106b65:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106b6b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106b6e:	76 48                	jbe    80106bb8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b70:	8b 45 08             	mov    0x8(%ebp),%eax
80106b73:	31 c9                	xor    %ecx,%ecx
80106b75:	89 fa                	mov    %edi,%edx
80106b77:	e8 34 f8 ff ff       	call   801063b0 <walkpgdir>
80106b7c:	85 c0                	test   %eax,%eax
80106b7e:	74 62                	je     80106be2 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80106b80:	8b 00                	mov    (%eax),%eax
80106b82:	a8 01                	test   $0x1,%al
80106b84:	74 50                	je     80106bd6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106b86:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106b88:	25 ff 0f 00 00       	and    $0xfff,%eax
80106b8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b90:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106b96:	e8 05 b9 ff ff       	call   801024a0 <kalloc>
80106b9b:	85 c0                	test   %eax,%eax
80106b9d:	89 c3                	mov    %eax,%ebx
80106b9f:	75 87                	jne    80106b28 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ba4:	89 04 24             	mov    %eax,(%esp)
80106ba7:	e8 f4 fd ff ff       	call   801069a0 <freevm>
  return 0;
80106bac:	31 c0                	xor    %eax,%eax
}
80106bae:	83 c4 2c             	add    $0x2c,%esp
80106bb1:	5b                   	pop    %ebx
80106bb2:	5e                   	pop    %esi
80106bb3:	5f                   	pop    %edi
80106bb4:	5d                   	pop    %ebp
80106bb5:	c3                   	ret    
80106bb6:	66 90                	xchg   %ax,%ax
80106bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bbb:	83 c4 2c             	add    $0x2c,%esp
80106bbe:	5b                   	pop    %ebx
80106bbf:	5e                   	pop    %esi
80106bc0:	5f                   	pop    %edi
80106bc1:	5d                   	pop    %ebp
80106bc2:	c3                   	ret    
80106bc3:	90                   	nop
80106bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106bc8:	89 1c 24             	mov    %ebx,(%esp)
80106bcb:	e8 20 b7 ff ff       	call   801022f0 <kfree>
      goto bad;
80106bd0:	eb cf                	jmp    80106ba1 <copyuvm+0xa1>
    return 0;
80106bd2:	31 c0                	xor    %eax,%eax
80106bd4:	eb d8                	jmp    80106bae <copyuvm+0xae>
      panic("copyuvm: page not present");
80106bd6:	c7 04 24 72 76 10 80 	movl   $0x80107672,(%esp)
80106bdd:	e8 7e 97 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106be2:	c7 04 24 58 76 10 80 	movl   $0x80107658,(%esp)
80106be9:	e8 72 97 ff ff       	call   80100360 <panic>
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106bf0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106bf1:	31 c9                	xor    %ecx,%ecx
{
80106bf3:	89 e5                	mov    %esp,%ebp
80106bf5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfe:	e8 ad f7 ff ff       	call   801063b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c03:	8b 00                	mov    (%eax),%eax
80106c05:	89 c2                	mov    %eax,%edx
80106c07:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c0a:	83 fa 05             	cmp    $0x5,%edx
80106c0d:	75 11                	jne    80106c20 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c14:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c19:	c9                   	leave  
80106c1a:	c3                   	ret    
80106c1b:	90                   	nop
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106c20:	31 c0                	xor    %eax,%eax
}
80106c22:	c9                   	leave  
80106c23:	c3                   	ret    
80106c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	83 ec 1c             	sub    $0x1c,%esp
80106c39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c42:	85 db                	test   %ebx,%ebx
80106c44:	75 3a                	jne    80106c80 <copyout+0x50>
80106c46:	eb 68                	jmp    80106cb0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106c48:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c4b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106c4d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106c51:	29 ca                	sub    %ecx,%edx
80106c53:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106c59:	39 da                	cmp    %ebx,%edx
80106c5b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106c5e:	29 f1                	sub    %esi,%ecx
80106c60:	01 c8                	add    %ecx,%eax
80106c62:	89 54 24 08          	mov    %edx,0x8(%esp)
80106c66:	89 04 24             	mov    %eax,(%esp)
80106c69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106c6c:	e8 7f d7 ff ff       	call   801043f0 <memmove>
    len -= n;
    buf += n;
80106c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106c74:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106c7a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106c7c:	29 d3                	sub    %edx,%ebx
80106c7e:	74 30                	je     80106cb0 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106c80:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106c83:	89 ce                	mov    %ecx,%esi
80106c85:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106c8b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106c8f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106c92:	89 04 24             	mov    %eax,(%esp)
80106c95:	e8 56 ff ff ff       	call   80106bf0 <uva2ka>
    if(pa0 == 0)
80106c9a:	85 c0                	test   %eax,%eax
80106c9c:	75 aa                	jne    80106c48 <copyout+0x18>
  }
  return 0;
}
80106c9e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ca6:	5b                   	pop    %ebx
80106ca7:	5e                   	pop    %esi
80106ca8:	5f                   	pop    %edi
80106ca9:	5d                   	pop    %ebp
80106caa:	c3                   	ret    
80106cab:	90                   	nop
80106cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cb0:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106cb3:	31 c0                	xor    %eax,%eax
}
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    
