import java.awt.Toolkit;
import java.awt.datatransfer.*;
layerMenu LayerList=new layerMenu();
allCurves DrawnCurves=new allCurves();
Button plusShape=new Button(439,470,"Add a new shape",110);
altButton plusQuadrilateral=new altButton(469,470,"Add a quadrilateral",122);
altButton plusEllipse=new altButton(499,470,"Add an approximate ellipse",170);
altButton plusTriangle=new altButton(529,470,"Add an isosceles triangle",153);
altButton moveCoordinates=new altButton(407,12,"Move the origin",97);
Button toggleOrigin=new Button(407,42,"Toggle the origin between standard/centered",272);
Button minusSegment=new Button(407,72,"Delete the last segment",145);
Button copyCode=new Button(407,102,"Copy the output code to the clipboard",229);

void setup()
{
  size(700,525);
}

class Button
{ float counter,buttonX,buttonY,ttLength;
  boolean mousedOver;
  String tooltip;
  Button(float bX, float bY, String tt, float ttL)
  { counter=0;
    buttonX=bX;
    buttonY=bY;
    tooltip=tt;
    ttLength=ttL;
    mousedOver=false;}
  void updateButton()
  {
    pushStyle();
      pushMatrix();
        translate(buttonX,buttonY);
        strokeWeight(1);
        stroke(75);
        if(mouseX>buttonX && mouseX<buttonX+25 && mouseY>buttonY && mouseY<buttonY+25)
        {fill(120);
        mousedOver=true;}
        else
        {fill(150);
        mousedOver=false;}
        rect(0,0,25,25);
      popMatrix();
    popStyle();
  }
  void updateTooltip()
  {
    pushStyle();
      if(mousedOver)
      {counter++;}
      else
      {counter=0;}
      if(mousedOver && counter>=60)
      { strokeWeight(1);
        stroke(100);
        fill(220,220,200);
        rect(mouseX+5,mouseY-25,ttLength,20);
        fill(0);
        text(tooltip,mouseX+10,mouseY-10);}
    popStyle();
  }
}

class altButton
{ float counter,buttonX,buttonY,ttLength;
  boolean mousedOver;
  String tooltip;
  altButton(float bX, float bY, String tt, float ttL)
  { counter=0;
    buttonX=bX;
    buttonY=bY;
    tooltip=tt;
    ttLength=ttL;
    mousedOver=false;}
  void updateButton(boolean isClicked)
  {
    pushStyle();
      pushMatrix();
        translate(buttonX,buttonY);
        strokeWeight(1);
        stroke(75);
        if((mouseX>buttonX && mouseX<buttonX+25 && mouseY>buttonY && mouseY<buttonY+25) || isClicked)
        {fill(120);}
        else
        {fill(150);}
        if(mouseX>buttonX && mouseX<buttonX+25 && mouseY>buttonY && mouseY<buttonY+25)
        {mousedOver=true;}
        else
        {mousedOver=false;}
        rect(0,0,25,25);
      popMatrix();
    popStyle();
  }
  void updateTooltip()
  {
    pushStyle();
      if(mousedOver)
      {counter++;}
      else
      {counter=0;}
      if(mousedOver && counter>=60)
      { strokeWeight(1);
        stroke(100);
        fill(220,220,200);
        rect(mouseX+5,mouseY-25,ttLength,20);
        fill(0);
        text(tooltip,mouseX+10,mouseY-10);}
    popStyle();
  }
}

class layerMenu 
{ ArrayList<layerButton> buttons;
  int mousedLayer;
  float layerScroll,layerCounter;
  layerMenu()
  { buttons=new ArrayList<layerButton>();
    buttons.add(new layerButton(buttons.size()));
    mousedLayer=0;
    layerScroll=0;}
  void updateMenu()
  {
    for(int i=0;i<buttons.size();i++)
    { layerButton tempButton = buttons.get(i);
      tempButton.updateButton(i,layerScroll);
      if(tempButton.mousedOver(layerScroll) && mousePressed && mouseButton==LEFT)
      {mousedLayer=mousedButton(0);}
    }
    layerCounter=(buttons.size()*43)+3;
    if(layerScroll>0 || (layerCounter<460 && layerScroll!=0))
    {layerScroll=0;}
    if(layerCounter>460 && (layerScroll+layerCounter)<460)
    {layerScroll=460-layerCounter;}
  }
  void addButton()
  {
    buttons.add(new layerButton(buttons.size()));
    mousedLayer=buttons.size()-1;
  }
  int mousedButton(int temp)
  {
    for(int i=0;i<buttons.size();i++)
    { layerButton tempButton = buttons.get(i);
      if(tempButton.mousedOver(layerScroll))
      {temp=i;}
    }
    return temp;
  }
}

class layerButton 
{ float layerID;
  layerButton(float lID)
  {layerID=lID;}
  void updateButton(float lID, float lScroll)
  {
    layerID=lID;
    pushMatrix();
      translate(443,(layerID*43)+3+lScroll);
      pushStyle();
        strokeWeight(1.5);
        stroke(140);
        if(layerID==LayerList.mousedLayer)
        {fill(200);}
        else
        {fill(175);}
        rect(0,0,252,40);
        fill(0);
        text("Shape "+int(lID+1),13,26);
        stroke(100);
        strokeWeight(1);
        noFill();
        rect(224,13,14,14);
        if(nestButton(lScroll))
        {strokeWeight(2);}
        else
        {strokeWeight(1);}
        line(236,15,226,25);
        line(226,15,236,25);
      popStyle();
    popMatrix();
  }
  boolean mousedOver(float lS)
  {
    if(mouseX>443 && mouseX<695 && mouseY>(layerID*43)+3+lS && mouseY<(layerID*43)+43+lS)
    {return true;}
    else
    {return false;}
  }
  boolean nestButton(float lS)
  {
    if(mouseX>668 && mouseX<684 && mouseY>(layerID*43)+16+lS && mouseY<(layerID*43)+32+lS)
    {return true;}
    else
    {return false;}
  }
}

class allCurves
{ ArrayList<bezierShape> shapes;
  float curveScroll,x0,y0,offsetX,offsetY,lineCounter;
  String outputCode;
  boolean triCounter,addTriang,ellCounter,addEllip,quadCounter,addQuad,editOrigin,originMoused;
  allCurves()
  { shapes=new ArrayList<bezierShape>();
    shapes.add(new bezierShape());
    curveScroll=0;
    outputCode="";
    triCounter=false;
    addTriang=false;
    ellCounter=false;
    addEllip=false;
    quadCounter=false;
    addQuad=false;
    offsetX=0;
    offsetY=0;
    originMoused=false;}
  void updateCurves()
  {
    if(editOrigin)
    { if((pmouseX>offsetX-5 && pmouseX<offsetX+5) || (pmouseY>offsetY-5 && pmouseY<offsetY+5))
      {originMoused=true;}
      else
      {originMoused=false;}
      if(mouseX>0 && mouseX<400 && mouseY>0 && mouseY<400)
      { if(mousePressed && mouseButton==LEFT && pmouseX>offsetX-5 && pmouseX<offsetX+5)
        { offsetX=mouseX;
          pushStyle();
            fill(150);
            if(offsetX<360)
            {textAlign(LEFT);text("("+int(offsetX)+")",offsetX+5,15);}
            else
            {textAlign(RIGHT);text("("+int(offsetX)+")",offsetX-5,15);}
          popStyle();}
        if(mousePressed && mouseButton==LEFT && pmouseY>offsetY-5 && pmouseY<offsetY+5)
        { offsetY=mouseY;
          pushStyle();
            fill(150);
            if(offsetY>15)
            {text("("+int(offsetY)+")",4,offsetY-6);}
            else
            {text("("+int(offsetY)+")",4,offsetY+15);}
          popStyle();
        }
      }
      pushStyle();
        strokeWeight(1);
        stroke(200);
        for(int i=0;i<400;i+=10)
        {line(i,offsetY,i+5,offsetY);}
        for(int i=0;i<400;i+=10)
        {line(offsetX,i,offsetX,i+5);}
      popStyle();
    }
    else
    {originMoused=false;}
    if(addTriang)
    { if(triCounter && mousePressed && mouseButton==LEFT && mouseX<400 && mouseY<400)
      { x0=mouseX;
        y0=mouseY;
        shapes.add(new bezierShape());
        bezierShape tempShape = shapes.get(shapes.size()-1);
        tempShape.addTriangle(x0,y0);
        LayerList.addButton();
        triCounter=false;}
      else if(mousePressed && mouseButton==LEFT && mouseX<400 && mouseY<400)
      { bezierShape tempShape = shapes.get(shapes.size()-1);
        tempShape.setTriangle();
      }
    }
    if(addEllip)
    { if(ellCounter && mousePressed && mouseButton==LEFT && mouseX<400 && mouseY<400)
      { x0=mouseX;
        y0=mouseY;
        shapes.add(new bezierShape());
        bezierShape tempShape = shapes.get(shapes.size()-1);
        tempShape.addEllipse(x0,y0);
        LayerList.addButton();
        ellCounter=false;}
      else if(mousePressed && mouseButton==LEFT && mouseX<400 && mouseY<400)
      { bezierShape tempShape = shapes.get(shapes.size()-1);
        tempShape.setEllipse();
      }
    }
    if(addQuad)
    { if(quadCounter && mousePressed && mouseButton==LEFT && mouseX<400 && mouseY<400)
      { x0=mouseX;
        y0=mouseY;
        shapes.add(new bezierShape());
        bezierShape tempShape = shapes.get(shapes.size()-1);
        tempShape.addQuadrilateral(x0,y0);
        LayerList.addButton();
        quadCounter=false;
      }
      else if(mousePressed && mouseButton==LEFT && mouseX<400 && mouseY<400)
      { bezierShape tempShape = shapes.get(shapes.size()-1);
        tempShape.setQuadrilateral();
      }
    }
    for(int i=0;i<shapes.size();i++)
    { bezierShape tempShape = shapes.get(i);
      tempShape.updateShape(i);
    }
  }  
  void codeOutput(float oX, float oY)
  {
    pushMatrix();
      translate(oX,oY);
      translate(0,curveScroll);
      pushStyle();
        fill(0);
        textAlign(LEFT,BASELINE);
        outputCode="";
        lineCounter=0;
        for(int i=0;i<shapes.size();i++)
        { bezierShape writeShape = shapes.get(i);
          bezierSegment writeSegment = writeShape.segments.get(0);
          outputCode+="//Shape " + (i + 1) + "\nbeginShape();\n  vertex("+int(writeSegment.point1X-offsetX)+","+int(writeSegment.point1Y-offsetY)+");\n  bezierVertex("+int(writeSegment.handle1X-offsetX)+","+int(writeSegment.handle1Y-offsetY)+","+int(writeSegment.handle2X-offsetX)+","+int(writeSegment.handle2Y-offsetY)+","+int(writeSegment.point2X-offsetX)+","+int(writeSegment.point2Y-offsetY)+");\n";
          lineCounter+=42;
          for(int j=1;j<writeShape.segments.size();j++)
          { writeSegment = writeShape.segments.get(j);
            outputCode+="  bezierVertex("+int(writeSegment.handle1X-offsetX)+","+int(writeSegment.handle1Y-offsetY)+","+int(writeSegment.handle2X-offsetX)+","+int(writeSegment.handle2Y-offsetY)+","+int(writeSegment.point2X-offsetX)+","+int(writeSegment.point2Y-offsetY)+");\n";
            lineCounter+=14;}
          outputCode+="endShape(OPEN);\n";
          lineCounter+=14;}
        text(outputCode,0,14);
      popStyle();
    popMatrix();
    if(curveScroll>0 || (lineCounter<90 && curveScroll!=0))
    {curveScroll=0;}
    if(lineCounter>90 && (curveScroll+405+lineCounter)<490)
    {curveScroll=490-(405+lineCounter);}
  }
} 

class bezierShape
{ ArrayList<bezierSegment> segments;
  float x0,y0;
  bezierShape()
  { segments=new ArrayList<bezierSegment>();
    segments.add(new bezierSegment(100,300,300,100,segments.size()));}
  void updateShape(int curShape)
  {
    for(int i=0;i<segments.size();i++)
    { bezierSegment currentSegment = segments.get(i);
      currentSegment.updatePoints();
      if(LayerList.mousedLayer==curShape)
      { currentSegment.showHandles=true;
        currentSegment.movePoints(curShape,i);}
      else
      {currentSegment.showHandles=false;}
    }
  }
  void addSegment()
  {
    bezierSegment lastSegment = segments.get(segments.size()-1);
    segments.add(new bezierSegment(lastSegment.point2X,lastSegment.point2Y,mouseX,mouseY,segments.size()));
  }
  void removeSegment()
  {
    if(segments.size()>1)
    {segments.remove(segments.size()-1);}
  }
  void addTriangle(float x, float y)
  {
    x0=x;
    y0=y;
    bezierSegment firstSegment = segments.get(0);
    firstSegment.point1X=((mouseX-x0)/2)+x0;
    firstSegment.point1Y=y0;
    firstSegment.point2X=mouseX;
    firstSegment.point2Y=mouseY;
    PVector distance = new PVector(firstSegment.point2X-firstSegment.point1X,firstSegment.point2Y-firstSegment.point1Y);
    distance.div(3);
    firstSegment.handle1X=firstSegment.point1X+distance.x;
    firstSegment.handle1Y=firstSegment.point1Y+distance.y;
    firstSegment.handle2X=firstSegment.point2X-distance.x;
    firstSegment.handle2Y=firstSegment.point2Y-distance.y;
    segments.add(new bezierSegment(mouseX,mouseY,x0,mouseY,segments.size()));
    segments.add(new bezierSegment(x0,mouseY,((mouseX-x0)/2)+x0,y0,segments.size()));
  }
  void setTriangle()
  {
    segments.remove(2); 
    segments.remove(1);
    bezierSegment firstSegment = segments.get(0);
    firstSegment.point1X=((mouseX-x0)/2)+x0;
    firstSegment.point1Y=y0;
    firstSegment.point2X=mouseX;
    firstSegment.point2Y=mouseY;
    PVector distance = new PVector(firstSegment.point2X-firstSegment.point1X,firstSegment.point2Y-firstSegment.point1Y);
    distance.div(3);
    firstSegment.handle1X=firstSegment.point1X+distance.x;
    firstSegment.handle1Y=firstSegment.point1Y+distance.y;
    firstSegment.handle2X=firstSegment.point2X-distance.x;
    firstSegment.handle2Y=firstSegment.point2Y-distance.y;
    segments.add(new bezierSegment(mouseX,mouseY,x0,mouseY,segments.size()));
    segments.add(new bezierSegment(x0,mouseY,((mouseX-x0)/2)+x0,y0,segments.size()));
  }
  void addQuadrilateral(float x, float y)
  {
    x0=x;
    y0=y;
    bezierSegment firstSegment = segments.get(0);
    firstSegment.point1X=x0;
    firstSegment.point1Y=y0;
    firstSegment.point2X=mouseX;
    firstSegment.point2Y=y0;
    PVector distance = new PVector(firstSegment.point2X-firstSegment.point1X,firstSegment.point2Y-firstSegment.point1Y);
    distance.div(3);
    firstSegment.handle1X=firstSegment.point1X+distance.x;
    firstSegment.handle1Y=firstSegment.point1Y+distance.y;
    firstSegment.handle2X=firstSegment.point2X-distance.x;
    firstSegment.handle2Y=firstSegment.point2Y-distance.y;
    segments.add(new bezierSegment(mouseX,y0,mouseX,mouseY,segments.size()));
    segments.add(new bezierSegment(mouseX,mouseY,x0,mouseY,segments.size()));
    segments.add(new bezierSegment(x0,mouseY,x0,y0,segments.size()));
  }
  void setQuadrilateral()
  {
    segments.remove(3);
    segments.remove(2);
    segments.remove(1);
    bezierSegment firstSegment = segments.get(0);
    firstSegment.point1X=x0;
    firstSegment.point1Y=y0;
    firstSegment.point2X=mouseX;
    firstSegment.point2Y=y0;
    PVector distance = new PVector(firstSegment.point2X-firstSegment.point1X,firstSegment.point2Y-firstSegment.point1Y);
    distance.div(3);
    firstSegment.handle1X=firstSegment.point1X+distance.x;
    firstSegment.handle1Y=firstSegment.point1Y+distance.y;
    firstSegment.handle2X=firstSegment.point2X-distance.x;
    firstSegment.handle2Y=firstSegment.point2Y-distance.y;
    segments.add(new bezierSegment(mouseX,y0,mouseX,mouseY,segments.size()));
    segments.add(new bezierSegment(mouseX,mouseY,x0,mouseY,segments.size()));
    segments.add(new bezierSegment(x0,mouseY,x0,y0,segments.size()));
  }
  void addEllipse(float x, float y)
  {
    x0=x;
    y0=y;
    bezierSegment firstSegment = segments.get(0);
    firstSegment.point1X=((mouseX-x0)/2)+x0;
    firstSegment.point1Y=y0;
    firstSegment.point2X=mouseX;
    firstSegment.point2Y=((mouseY-y0)/2)+y0;
    firstSegment.handle1X=((mouseX-x0)*.775)+x0;
    firstSegment.handle1Y=y0;
    firstSegment.handle2X=mouseX;
    firstSegment.handle2Y=((mouseY-y0)*.225)+y0;
    segments.add(new bezierSegment(mouseX,((mouseY-y0)/2)+y0,((mouseX-x0)/2)+x0,mouseY,segments.size()));
    bezierSegment nextSegment = segments.get(1);
    nextSegment.handle1X=mouseX;
    nextSegment.handle1Y=((mouseY-y0)*.775)+y0;
    nextSegment.handle2X=((mouseX-x0)*.775)+x0;
    nextSegment.handle2Y=mouseY;
    segments.add(new bezierSegment(((mouseX-x0)/2)+x0,mouseY,x0,((mouseY-y0)/2)+y0,segments.size()));
    nextSegment = segments.get(2);
    nextSegment.handle1X=((mouseX-x0)*.225)+x0;
    nextSegment.handle1Y=mouseY;
    nextSegment.handle2X=x0;
    nextSegment.handle2Y=((mouseY-y0)*.775)+y0;
    segments.add(new bezierSegment(x0,((mouseY-y0)/2)+y0,((mouseX-x0)/2)+x0,y0,segments.size()));
    nextSegment = segments.get(3);
    nextSegment.handle1X=x0;
    nextSegment.handle1Y=((mouseY-y0)*.225)+y0;
    nextSegment.handle2X=((mouseX-x0)*.225)+x0;
    nextSegment.handle2Y=y0;
  }
  void setEllipse()
  {
    segments.remove(3);
    segments.remove(2);
    segments.remove(1);
    bezierSegment firstSegment = segments.get(0);
    firstSegment.point1X=((mouseX-x0)/2)+x0;
    firstSegment.point1Y=y0;
    firstSegment.point2X=mouseX;
    firstSegment.point2Y=((mouseY-y0)/2)+y0;
    firstSegment.handle1X=((mouseX-x0)*.775)+x0;
    firstSegment.handle1Y=y0;
    firstSegment.handle2X=mouseX;
    firstSegment.handle2Y=((mouseY-y0)*.225)+y0;
    segments.add(new bezierSegment(mouseX,((mouseY-y0)/2)+y0,((mouseX-x0)/2)+x0,mouseY,segments.size()));
    bezierSegment nextSegment = segments.get(1);
    nextSegment.handle1X=mouseX;
    nextSegment.handle1Y=((mouseY-y0)*.775)+y0;
    nextSegment.handle2X=((mouseX-x0)*.775)+x0;
    nextSegment.handle2Y=mouseY;
    segments.add(new bezierSegment(((mouseX-x0)/2)+x0,mouseY,x0,((mouseY-y0)/2)+y0,segments.size()));
    nextSegment = segments.get(2);
    nextSegment.handle1X=((mouseX-x0)*.225)+x0;
    nextSegment.handle1Y=mouseY;
    nextSegment.handle2X=x0;
    nextSegment.handle2Y=((mouseY-y0)*.775)+y0;
    segments.add(new bezierSegment(x0,((mouseY-y0)/2)+y0,((mouseX-x0)/2)+x0,y0,segments.size()));
    nextSegment = segments.get(3);
    nextSegment.handle1X=x0;
    nextSegment.handle1Y=((mouseY-y0)*.225)+y0;
    nextSegment.handle2X=((mouseX-x0)*.225)+x0;
    nextSegment.handle2Y=y0;
  }
  boolean otherActive(boolean temp, int tempCurSeg)
  {
    for(int i=0;i<segments.size();i++)
    { if(i!=tempCurSeg)
      { bezierSegment tempSegment = segments.get(i);
        if(tempSegment.active)
        {temp=true;}
      }
    }
    return temp;
  }
}  

class bezierSegment
{ float point1X,point1Y,point2X,point2Y,handle1X,handle1Y,handle2X,handle2Y,numSegments;
  PVector distance;
  boolean active,showHandles;
  bezierSegment(float p1X, float p1Y, float p2X, float p2Y, float quan)
  { point1X=p1X;
    point1Y=p1Y;
    point2X=p2X;
    point2Y=p2Y;
    numSegments=quan;
    if(numSegments<1)
    { handle1X=100;
      handle1Y=200;
      handle2X=300;
      handle2Y=200;}
    else
    { distance = new PVector(point2X-point1X,point2Y-point1Y);
      distance.div(3); 
      handle1X=point1X+distance.x;
      handle1Y=point1Y+distance.y;
      handle2X=point2X-distance.x;
      handle2Y=point2Y-distance.y;}
    showHandles=false;
    active=false;}
  void updatePoints()
  {
    pushStyle();
      noFill();
      if(showHandles)
      {strokeWeight(2);}
      else
      {strokeWeight(1);}
      stroke(0);
      beginShape();
        vertex(point1X,point1Y);
        bezierVertex(handle1X,handle1Y,handle2X,handle2Y,point2X,point2Y);
      endShape(OPEN);
      if(showHandles)
      { strokeWeight(1);
        stroke(200,70,50);
        line(point1X,point1Y,handle1X,handle1Y);
        line(point2X,point2Y,handle2X,handle2Y);
        noStroke();
        fill(0);
        ellipse(point1X,point1Y,4,4);
        ellipse(point2X,point2Y,4,4);
        fill(200,70,50);
        ellipse(handle1X,handle1Y,4,4);
        ellipse(handle2X,handle2Y,4,4);}
    popStyle();
  }
  void movePoints(int shapeID, int segmentID)
  { 
    bezierShape currentShape = DrawnCurves.shapes.get(shapeID);
    if(mousePressed && mouseButton==LEFT && mouseX>0 && mouseX<400 && mouseY>0 && mouseY<400 && !currentShape.otherActive(false,segmentID) && !DrawnCurves.editOrigin)
    { if(pmouseX>handle1X-5 && pmouseX<handle1X+5 && pmouseY>handle1Y-5 && pmouseY<handle1Y+5)
      { handle1X=mouseX;
        handle1Y=mouseY;
        active=true;
      }else if(pmouseX>handle2X-5 && pmouseX<handle2X+5 && pmouseY>handle2Y-5 && pmouseY<handle2Y+5)
      { handle2X=mouseX;
        handle2Y=mouseY;
        active=true;
      }else if(pmouseX>point1X-5 && pmouseX<point1X+5 && pmouseY>point1Y-5 && pmouseY<point1Y+5)
      { point1X=mouseX;
        point1Y=mouseY;
        if(segmentID>0)
        { bezierSegment prevSegment = currentShape.segments.get(segmentID-1);
          prevSegment.point2X=mouseX;
          prevSegment.point2Y=mouseY;}
        active=true;
      }else if(pmouseX>point2X-5 && pmouseX<point2X+5 && pmouseY>point2Y-5 && pmouseY<point2Y+5)
      { point2X=mouseX;
        point2Y=mouseY;
        if(segmentID+1<currentShape.segments.size())
        { bezierSegment nextSegment = currentShape.segments.get(segmentID+1);
          nextSegment.point1X=mouseX;
          nextSegment.point1Y=mouseY;}
        active=true;
      }else
      {active=false;}
    }
  }
}

void draw()
{
  background(190,200,210,150);
  DrawnCurves.codeOutput(10,405);
  pushStyle();
    noFill();
    stroke(155,165,175);
    strokeWeight(3);
    rect(0,0,700,499);
    noStroke();
    fill(120);
    rect(0,0,402,402);
    fill(255);
    rect(0,0,400,400);
    fill(120);
    rect(402,5,37,129);
    fill(155,165,175);
    rect(402,7,35,125);
  popStyle();
  LayerList.updateMenu();
  pushStyle();
    noStroke();
    fill(120);
    rect(432,463,266,37);
    fill(155,165,175);
    rect(434,465,262,35);
  popStyle();
  plusShape.updateButton();
  plusQuadrilateral.updateButton(DrawnCurves.addQuad);
  plusEllipse.updateButton(DrawnCurves.addEllip);
  plusTriangle.updateButton(DrawnCurves.addTriang);
  moveCoordinates.updateButton(DrawnCurves.editOrigin);
  toggleOrigin.updateButton();
  minusSegment.updateButton();
  copyCode.updateButton();
  pushStyle();
    pushMatrix();
      translate(0, 500);
      noStroke();
      fill(220);
      rect(0,0,700,25);
      fill(0);
      text("Graphical Bezier Curve Editor, v4.0 (December 2013).              Created by Christopher Siu for Julie Workman's CPE 123", 7, 16);
    popMatrix();
    pushMatrix();
      translate(439,470);
      noFill();
      strokeWeight(1);
      stroke(50);
      beginShape();
        vertex(5,20);
        bezierVertex(5,10,20,15,20,5);
      endShape(OPEN);
      line(5,10,5,20);
      line(20,5,20,15);
      fill(50);
      ellipse(5,10,1,1);
      ellipse(5,20,1,1);
      ellipse(20,5,1,1);
      ellipse(20,15,1,1);
      strokeWeight(1.5);
      stroke(0);
      line(12,18,22,18);
      line(17,13,17,23);
    popMatrix();
    pushMatrix();
      translate(469,470);
      noFill();
      strokeWeight(1);
      stroke(50);
      beginShape();
        vertex(5,5);
        vertex(20,5);
        vertex(20,15);
        vertex(5,15);
      endShape(CLOSE);
      fill(50);
      ellipse(5,5,1,1);
      ellipse(20,5,1,1);
      ellipse(20,15,1,1);
      ellipse(5,15,1,1);
      strokeWeight(1.5);
      stroke(0);
      line(12,18,22,18);
      line(17,13,17,23);
    popMatrix();
    pushMatrix();
      translate(499,470);
      noFill();
      strokeWeight(1);
      stroke(50);
      beginShape();
        vertex(12,5);
        bezierVertex(16,5,19,8,19,12);
        bezierVertex(19,16,16,19,12,19);
        bezierVertex(8,19,5,16,5,12);
        bezierVertex(5,8,8,5,12,5);
      endShape(CLOSE);
      line(8,5,16,5);
      line(19,8,19,16);
      line(16,19,8,19);
      line(5,16,5,8);
      fill(50);
      ellipse(8,5,1,1);
      ellipse(12,5,1,1);
      ellipse(16,5,1,1);
      ellipse(19,8,1,1);
      ellipse(19,12,1,1);
      ellipse(19,16,1,1);
      ellipse(16,19,1,1);
      ellipse(12,19,1,1);
      ellipse(8,19,1,1);
      ellipse(5,16,1,1);
      ellipse(5,12,1,1);
      ellipse(5,8,1,1);
      strokeWeight(1.5);
      stroke(0);
      line(12,18,22,18);
      line(17,13,17,23);
    popMatrix();
    pushMatrix();
      translate(529,470);
      noFill();
      strokeWeight(1);
      stroke(50);
      beginShape();
        vertex(12,5);
        vertex(20,20);
        vertex(5,20);
      endShape(CLOSE);
      fill(50);
      ellipse(12,5,1,1);
      ellipse(20,20,1,1);
      ellipse(5,20,1,1);
      strokeWeight(1.5);
      stroke(0);
      line(12,18,22,18);
      line(17,13,17,23);
    popMatrix();
    pushMatrix();
      translate(407,12);
      noFill();
      strokeWeight(1);
      stroke(50);
      for(int i=0;i<25;i+=3)
      {line(i,7,i+1,7);}
      for(int i=0;i<25;i+=3)
      {line(7,i,7,i+1);}
      strokeWeight(1.5);
      stroke(0);
      beginShape();
        vertex(10,10);
        vertex(22,15);
        vertex(17,17);
        vertex(15,22);
      endShape(CLOSE);
    popMatrix();
    pushMatrix();
      translate(407,42);
      noFill();
      strokeWeight(1);
      stroke(50);
      for(int i=0;i<25;i+=3)
      {line(i,2,i+1,2);}
      for(int i=0;i<25;i+=3)
      {line(i,15,i+1,15);}
      for(int i=0;i<25;i+=3)
      {line(2,i,2,i+1);}
      for(int i=0;i<25;i+=3)
      {line(15,i,15,i+1);}
      strokeWeight(1.5);
      stroke(0);
      line(4,9,2,2);
      line(9,4,2,2);
      line(2,2,15,15);
      line(8,13,15,15);
      line(15,15,13,8);
    popMatrix();
    pushMatrix();
      translate(407,72);
      noFill();
      strokeWeight(1);
      stroke(50);
      beginShape();
        vertex(5,15);
        bezierVertex(5,5,10,5,20,5);
      endShape(OPEN);
      line(5,15,5,5);
      line(10,5,20,5);
      fill(50);
      ellipse(5,15,1,1);
      ellipse(5,5,1,1);
      ellipse(10,5,1,1);
      ellipse(20,5,1,1);
      strokeWeight(1.5);
      stroke(0);
      line(13,13,21,21);
      line(21,13,13,21);
    popMatrix();
    pushMatrix();
      translate(407,102);
      noFill();
      strokeWeight(1.5);
      stroke(0);
      beginShape();
        vertex(5,3);
        vertex(13,3);
        vertex(20,10);
        vertex(20,22);
        vertex(5,22);
      endShape(CLOSE);
      line(13,4,13,10);
      line(13,10,19,10);
      strokeWeight(1);
      stroke(50);
      line(7,7,13,7);
      line(7,11,18,11);
      line(7,15,18,15);
      line(7,19,18,19);
    popMatrix();
  popStyle();
  plusShape.updateTooltip();
  plusQuadrilateral.updateTooltip();
  plusEllipse.updateTooltip();
  plusTriangle.updateTooltip();
  moveCoordinates.updateTooltip();
  toggleOrigin.updateTooltip();
  minusSegment.updateTooltip();
  copyCode.updateTooltip();
  DrawnCurves.updateCurves();
  if(mouseX>0 && mouseX<400 && mouseY>0 && mouseY<400)
  { pushStyle();
      fill(0);
      if(mouseX<340 && mouseY>16)
      {textAlign(LEFT,BASELINE);
      text("("+int(mouseX-DrawnCurves.offsetX)+","+int(mouseY-DrawnCurves.offsetY)+")",mouseX+5,mouseY-5);}
      else if(mouseX>340 && mouseY>16)
      {textAlign(RIGHT,BASELINE);
      text("("+int(mouseX-DrawnCurves.offsetX)+","+int(mouseY-DrawnCurves.offsetY)+")",mouseX-5,mouseY-5);}
      else if(mouseX<340 && mouseY<16)
      {textAlign(LEFT,TOP);
      text("("+int(mouseX-DrawnCurves.offsetX)+","+int(mouseY-DrawnCurves.offsetY)+")",mouseX+5,mouseY+5);}
      else
      {textAlign(RIGHT,TOP);
      text("("+int(mouseX-DrawnCurves.offsetX)+","+int(mouseY-DrawnCurves.offsetY)+")",mouseX-5,mouseY+5);}
    popStyle();}
}

void mouseClicked()
{
  if(plusShape.mousedOver && mouseButton==LEFT)
  { DrawnCurves.shapes.add(new bezierShape());
    LayerList.addButton();
  }else if(plusQuadrilateral.mousedOver && mouseButton==LEFT)
  { if(!DrawnCurves.addQuad && !DrawnCurves.editOrigin)
    { DrawnCurves.addQuad=true;
      DrawnCurves.quadCounter=true;
    }
  }else if(plusEllipse.mousedOver && mouseButton==LEFT)
  { if(!DrawnCurves.addEllip && !DrawnCurves.editOrigin)
    { DrawnCurves.addEllip=true;
      DrawnCurves.ellCounter=true;
    }
  }else if(plusTriangle.mousedOver && mouseButton==LEFT)
  { if(!DrawnCurves.addTriang && !DrawnCurves.editOrigin)
    { DrawnCurves.addTriang=true;
      DrawnCurves.triCounter=true;
    }
  }else if(moveCoordinates.mousedOver && mouseButton==LEFT)
  { if(!DrawnCurves.editOrigin)
    {DrawnCurves.editOrigin=true;}
    else
    {DrawnCurves.editOrigin=false;}
  }else if(toggleOrigin.mousedOver && mouseButton==LEFT)
  { if(DrawnCurves.offsetX!=0 || DrawnCurves.offsetY!=0)
    { DrawnCurves.offsetX=0;
      DrawnCurves.offsetY=0;}
    else
    { DrawnCurves.offsetX=200;
      DrawnCurves.offsetY=200;}
  }else if(minusSegment.mousedOver && mouseButton==LEFT)
  { bezierShape tempShape = DrawnCurves.shapes.get(LayerList.mousedLayer);
    tempShape.removeSegment();
  }else if(copyCode.mousedOver && mouseButton==LEFT)
  { StringSelection stringSel=new StringSelection(DrawnCurves.outputCode);
    Toolkit toolkit=Toolkit.getDefaultToolkit();
    Clipboard clipboard=toolkit.getSystemClipboard();
    clipboard.setContents(stringSel,null);
  }else if(mouseX<400 && mouseY<400 && mouseButton==RIGHT)
  { bezierShape tempShape = DrawnCurves.shapes.get(LayerList.mousedLayer);
    tempShape.addSegment();
  }else if(mouseButton==LEFT)
  { for(int i=0;i<LayerList.buttons.size();i++)
    { layerButton tempButton = LayerList.buttons.get(i);
      if(tempButton.nestButton(LayerList.layerScroll) && DrawnCurves.shapes.size()>1)
      { DrawnCurves.shapes.remove(i);
        LayerList.buttons.remove(i);
        if(i!=0)
        {LayerList.mousedLayer=i-1;}
        else
        {LayerList.mousedLayer=i;}
      }
    }
  }
}

void mouseMoved()
{
  if(plusShape.mousedOver || plusQuadrilateral.mousedOver || plusEllipse.mousedOver || plusTriangle.mousedOver || moveCoordinates.mousedOver || toggleOrigin.mousedOver || minusSegment.mousedOver || copyCode.mousedOver)
  {cursor(HAND);
  }else if(DrawnCurves.originMoused)
  {cursor(CROSS);
  }else
  {cursor(ARROW);}
}

void mouseReleased()
{
  if(DrawnCurves.addTriang)
  {DrawnCurves.addTriang=false;}
  else if(DrawnCurves.addQuad && mouseX<400 && mouseY<400)
  {DrawnCurves.addQuad=false;}
  else if(DrawnCurves.addEllip && mouseX<400 && mouseY<400)
  {DrawnCurves.addEllip=false;} 
}

void mouseWheel(MouseEvent scrollDirection)
{
  if(mouseX<400 && mouseY>400 && DrawnCurves.lineCounter>90)
  {DrawnCurves.curveScroll+=-scrollDirection.getAmount();}
  if(mouseX>435 && LayerList.layerCounter>460)
  {LayerList.layerScroll+=-scrollDirection.getAmount();}
}
