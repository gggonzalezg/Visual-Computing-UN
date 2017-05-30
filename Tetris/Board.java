package Visual.Tetris;

import processing.core.*;

/**
 * Created by gggonzalezg on 5/29/17.
 */


public class Board extends Tetris{
    private int size, rows, cols;
    Tetramino[][] pieces;
    PApplet parent;

    public Board(int size, int rows, int cols, PApplet p) {
        this.size = size;
        this.rows = rows;
        this.cols = cols;
        this.parent = p;
        order();
    }

    private void order() {
        clear();

    }

    public void clear() {
        if (pieces != null)
            for (int i = 0; i < pieces.length; i++)
                for (int j = 0; j < pieces[0].length; j++)
                    scene.pruneBranch(pieces[i][j]);
    }

    public void update() {
        for (int y=0; y<size; y++)
            for (int x=0; x<size; x++)
                if (pieces[y][x] != null)
                    pieces[y][x].setPosition((float)(pieces[y][x].getSize() * ((float) x - (float) size / 2.0 + 0.5)), (float)(pieces[y][x].getSize() * ((float) y - (float) size / 2.0 + 0.5)), (float)(0));
    }

    public void movePiece() {
    }
}