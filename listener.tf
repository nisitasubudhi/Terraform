
listener_arn = aws_lb_listener.external-alb.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb.arn
  }
condition {
    path_pattern {
      values = ["/my_listener_rule/*"]
    }
  }
}
