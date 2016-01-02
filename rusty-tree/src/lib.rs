#![allow(dead_code)]
use Tree::*;
use std::collections::HashSet;

enum Tree {
    // Split: Tuple struct that wraps references to two child trees.
    Split(Box<Tree>, Box<Tree>),
    // Node: Tuple struct that wraps a numerical value and a reference to a child Tree.
    Node(u32, Box<Tree>),
    // Nil: Signifies the end of a branch.
    Nil,
}

impl Tree {
    fn new() -> Tree {
        Nil
    }

    fn from_branches(left: Tree, right: Tree) -> Tree {
        Split(Box::new(left), Box::new(right))
    }

    // Consume a tree, and return the same tree with a new element at its front
    fn prepend_node(self, val: u32) -> Tree {
        Node(val, Box::new(self))
    }

    fn is_leaf(&self) -> bool {
        match *self {
            Split(_,_) => false,
            Nil => false,
            Node(_, ref child) => {
                match **child {
                    Nil => true,
                    _ => false
                }
            }
        }
    }

    fn sum_branches(&self) -> HashSet<u32> {
        let mut set: HashSet<u32> = HashSet::new();
        match *self {
            Nil => {
                // Do nothing. Just return an empty set.
            }
            Split(ref left, ref right) => {
                for branch in &[left.sum_branches(), right.sum_branches()] {
                    for value in branch {
                        set.insert(*value);
                    }
                }
            }
            Node(val, ref child) => {
                match **child {
                    Nil => {set.insert(val);},
                    _ => {
                        for child_val in child.sum_branches() {
                            set.insert(child_val + val);
                        }
                    }
                }
            }
        }
        set
    }

    fn branch_from_sequence(seq: Vec<u32>) -> Tree {
        let mut branch = Tree::new();
        for num in seq.iter().rev() {
            branch = branch.prepend_node(*num);
        }
        branch
    }
}

#[test]
fn construct_and_sum() {
    let root_num = 42;
    let left_branch = Tree::branch_from_sequence(vec![4, 5, 6]);
    let right_branch = Tree::branch_from_sequence(vec![1, 2, 3]);

    let mut tree = Tree::from_branches(left_branch, right_branch);
    tree = tree.prepend_node(root_num);

    let sums = tree.sum_branches();
    assert!(sums.contains(&48));
    assert!(sums.contains(&57));
}
